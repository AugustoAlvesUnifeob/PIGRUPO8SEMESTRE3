import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class LogPHR {
  final String idSensor;
  final int leitura;
  final int lote;
  final DateTime dataHora;

  LogPHR({
    required this.idSensor,
    required this.leitura,
    required this.lote,
    required this.dataHora,
  });

  factory LogPHR.fromFirestore(Map<String, dynamic> json) {
    String dataString = json['dataleitura'];
    String horaString = json['horaleitura'];
    return LogPHR(
      idSensor: json['idSensor'] ?? '',
      leitura: json['leitura'] ?? 0,
      lote: json['lote'] ?? 0,
      dataHora: DateTime.parse("$dataString $horaString"),
    );
  }
}

class ContagemCortesService {
  final int metaDiaria = 2000;
  final int lote = 50;
  Stream<List<LogPHR>> getLogsPorData(DateTime dataSelecionada) {
    // Formata a data
    String dataFormatada =
        "${dataSelecionada.year}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}";

    return FirebaseFirestore.instance
        .collection('LogsPHR')
        .where('dataleitura', isEqualTo: dataFormatada)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    LogPHR.fromFirestore(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Future<Map<String, double>> buscarProducaoUltimos7Dias() async {
    DateTime hoje = DateTime.now();

    DateTime seteDiasAtras = hoje.subtract(const Duration(days: 6));

    String dataInicio =
        "${seteDiasAtras.year}-${seteDiasAtras.month.toString().padLeft(2, '0')}-${seteDiasAtras.day.toString().padLeft(2, '0')}";

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('LogsPHR')
          .where('dataleitura', isGreaterThanOrEqualTo: dataInicio)
          .get();

      List<String> nomesDias = [
        'Seg',
        'Ter',
        'Qua',
        'Qui',
        'Sex',
        'Sáb',
        'Dom',
      ];
      Map<String, double> producaoSemanal = {};

      for (int i = 6; i >= 0; i--) {
        DateTime dia = hoje.subtract(Duration(days: i));
        String nomeDia = nomesDias[dia.weekday - 1];
        producaoSemanal[nomeDia] = 0.0;
      }

      for (var doc in snapshot.docs) {
        LogPHR log = LogPHR.fromFirestore(doc.data() as Map<String, dynamic>);
        String nomeDia = nomesDias[log.dataHora.weekday - 1];

        if (producaoSemanal.containsKey(nomeDia)) {
          producaoSemanal[nomeDia] =
              producaoSemanal[nomeDia]! + log.leitura.toDouble();
        }
      }

      return producaoSemanal;
    } catch (e) {
      print("Erro ao buscar histórico de 7 dias: $e");
      return {};
    }
  }

  int calcularTotalPecas(List<LogPHR> logs) {
    return logs.fold(0, (soma, item) => soma + item.leitura);
  }

  double calcularPercentualMeta(int totalPecas) {
    if (metaDiaria <= 0) return 0.0;
    double percentual = totalPecas / metaDiaria;
    return percentual > 1.0 ? 1.0 : percentual;
  }

  List<FlSpot> gerarSpotsDoGrafico(List<LogPHR> logs) {
    Map<int, int> porHora = {};

    for (var log in logs) {
      int hora = log.dataHora.hour;
      porHora[hora] = (porHora[hora] ?? 0) + log.leitura;
    }

    var horasOrdenadas = porHora.keys.toList()..sort();

    return horasOrdenadas.map((hora) {
      return FlSpot(hora.toDouble(), porHora[hora]!.toDouble());
    }).toList();
  }
}
