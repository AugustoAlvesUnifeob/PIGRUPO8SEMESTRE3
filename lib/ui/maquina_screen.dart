import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/maquina.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/cortes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/ai_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MachineScreen extends StatefulWidget {
  const MachineScreen({super.key});

  @override
  State<MachineScreen> createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
  late Stream<List<LogPHR>> _logsStream;
  final AiService _aiService = AiService();
  final ContagemCortesService _service = ContagemCortesService();
  DateTime _dataSelecionada = DateTime.now();
  late Future<String?> _nomeMaquinaFuture;
  late Future<bool?> _estadoMaquinaFuture;

  @override
  void initState() {
    super.initState();
    _nomeMaquinaFuture = lerNomeMaquina();
    _estadoMaquinaFuture = lerEstadoMaquina();
    _logsStream = _service.getLogsPorData(_dataSelecionada);
  }

  Future<void> PoliticaPriv() async {
    final Uri url = Uri.parse('https://packbag.com.br/politica-de-privacidade');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    } else {
      throw Exception('Não foi possível abrir $url');
    }
  }

  Future<void> _escolherData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2026, 4, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.cinza, // Cor do header do DatePicker
              onPrimary: AppColors.branco, // Cor do texto do header
              onSurface: AppColors.branco, // Cor dos textos dos dias
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.branco, // Cor dos botões "Cancelar" e "OK"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null && dataEscolhida != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataEscolhida;
        _logsStream = _service.getLogsPorData(_dataSelecionada);
      });
    }
  }

  @override
  // App Bar
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      appBar: AppBar(
        backgroundColor: AppColors.cinza,
        iconTheme: IconThemeData(color: AppColors.preto),
        centerTitle: true,
        title: Image.asset(
          AppColors.logo,
          key: ValueKey(AppColors.logo),
          width: 160,
          height: 80,
          fit: BoxFit.contain,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                AppColors.mudarContraste();
              });
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: AppColors.cinzaClaro,
            ),
            child: Icon(Icons.accessibility, size: 30, color: AppColors.preto),
          ),
        ],
      ),

      body: StreamBuilder<List<LogPHR>>(
        stream: _logsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.cinza),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }
          final logs = snapshot.data ?? [];
          final int totalPecas = _service.calcularTotalPecas(logs);
          final double percentualMeta = _service.calcularPercentualMeta(
            totalPecas,
          );

          //Os elementos são construidos de baixo para cima, ou seja, aqui no SingleChild ele só chama eles, a construcao fica na parte inferior

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMachineInfoCard(),
                const SizedBox(height: 24),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '---------------',
                      style: TextStyle(color: AppColors.preto),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildGraficoMinutos(logs),
                const SizedBox(height: 20),

                _buildGraficoHoras(logs),
                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '---------------',
                      style: TextStyle(color: AppColors.preto),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildCardPecasCortadas(totalPecas),
                    _buildCardMeta(percentualMeta),
                  ],
                ),

                const SizedBox(height: 40),

                // grafico de producao nos dias
                FutureBuilder<Map<String, double>>(
                  future: ContagemCortesService().buscarProducaoUltimos7Dias(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Text(
                        "Não foi possível carregar o histórico.",
                      );
                    }
                    return _buildGraficoHistoricoDias(snapshot.data!);
                  },
                ),
                const SizedBox(height: 40),

                _buildAiInsightsSection(logs, _service.metaDiaria),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiInsightsSection(List<LogPHR> logs, int meta) {
    return FutureBuilder<String>(
      future: _aiService.gerarInsights(logs, meta),
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cinzaClaro,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.laranja),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.preto),
                  const SizedBox(width: 8),
                  Text(
                    "Insights:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.preto,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: LinearProgressIndicator())
              else if (snapshot.hasError)
                const Text("Erro ao carregar insights.")
              else
                Text(
                  snapshot.data ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.preto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMachineInfoCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cinzaClaro,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.pretoClaro,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: _nomeMaquinaFuture,
                builder: (context, snapshot) {
                  String nome = "Máquina de Corte";

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    nome = snapshot.data!;
                  }

                  return Text(
                    nome,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.preto,
                    ),
                  );
                },
              ),

              const SizedBox(height: 4),

              FutureBuilder<bool?>(
                future: _estadoMaquinaFuture,
                builder: (context, snapshot) {
                  bool ativo = snapshot.data ?? false;

                  return Text(
                    ativo ? "OPERANDO" : "PARADO",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ativo ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              Text(
                "ESP32: CONECTADO",
                style: TextStyle(fontSize: 12, color: AppColors.preto),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('lib/assets/esp32.png', width: 70),

                  ElevatedButton(
                    onPressed: () => _escolherData(context),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: AppColors.pretoClaro,
                    ),
                    child: Icon(
                      Icons.calendar_month,
                      size: 30,
                      color: AppColors.branco,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardPecasCortadas(int totalPecas) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.marrom,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Peças Cortadas',
            style: TextStyle(color: AppColors.branco, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.laranja,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '$totalPecas',
              style: TextStyle(
                fontSize: 48,
                color: AppColors.branco,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardMeta(double percentual) {
    int textoPorcentagem = (percentual * 100).toInt();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cinza,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'META',
            style: TextStyle(color: AppColors.branco, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.cinzaClaro,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '$textoPorcentagem%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cinza,
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: LinearPercentIndicator(
                  width: 140.0,
                  lineHeight: 30.0,
                  percent: percentual,
                  backgroundColor: Colors.white,
                  progressColor: Colors.green,
                  barRadius: const Radius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGraficoHoras(List<LogPHR> logs) {
    if (logs.isEmpty) return const SizedBox();

    Map<int, double> producaoPorHora = {};

    for (var log in logs) {
      int hora = log.dataHora.hour;
      producaoPorHora[hora] =
          (producaoPorHora[hora] ?? 0) + log.leitura.toDouble();
    }

    List<int> horasOrdenadas = producaoPorHora.keys.toList()..sort();

    List<FlSpot> spotsGrafico = [];
    for (int i = 0; i < horasOrdenadas.length; i++) {
      spotsGrafico.add(
        FlSpot(i.toDouble(), producaoPorHora[horasOrdenadas[i]]!),
      );
    }

    double intervaloX = horasOrdenadas.length > 6
        ? (horasOrdenadas.length / 5).ceil().toDouble()
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Produção nas últimas horas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: intervaloX,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= horasOrdenadas.length)
                          return const Text('');

                        // Pega a hora exata da nossa lista ordenada e formata
                        String horaFormatada =
                            "${horasOrdenadas[index].toString().padLeft(2, '0')}:00";

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            horaFormatada,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "${value.toInt()}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsGrafico.isEmpty
                        ? [const FlSpot(0, 0)]
                        : spotsGrafico,
                    isCurved: false,
                    color: Colors.deepOrange,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Grafico da producao em minutos
  Widget _buildGraficoMinutos(List<LogPHR> logs) {
    logs.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    
    List<FlSpot> spotsGrafico = [];
    for (int i = 0; i < logs.length; i++) {
      spotsGrafico.add(FlSpot(i.toDouble(), logs[i].leitura.toDouble()));
    }

    double intervaloX = logs.length > 5
        ? (logs.length / 5).ceil().toDouble()
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Produção por Minuto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: intervaloX,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= logs.length)
                          return const Text('');

                        // Formatação exata do minuto (Ex: 12:45)
                        DateTime data = logs[index].dataHora;
                        String minutoFormatado =
                            "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            minutoFormatado,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "${value.toInt()}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsGrafico.isEmpty
                        ? [const FlSpot(0, 0)]
                        : spotsGrafico,
                    isCurved: true,
                    color: Colors.deepOrange,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepOrange.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Grafico com a producao em dias diferentes (grafico de barras)
Widget _buildGraficoHistoricoDias(Map<String, double> producaoUltimosDias) {
  // Se ainda não carregou ou não tem dados, mostra um aviso ou fica vazio
  if (producaoUltimosDias.isEmpty) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: const Center(
        child: Text(
          "Carregando histórico...",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // Extrai as chaves (dias: Seg, Ter, Qua...) e valores (produção)
  List<String> dias = producaoUltimosDias.keys.toList();
  List<double> valores = producaoUltimosDias.values.toList();

  // Encontra o valor máximo para definir o teto do gráfico de forma dinâmica
  double maxValor = valores.reduce((a, b) => a > b ? a : b);
  // Se for zero, força um mínimo para o gráfico não quebrar
  if (maxValor == 0) maxValor = 10;

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Histórico de Produção (Últimos Dias)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValor * 1.2, // Deixa 20% de margem no topo
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxValor > 50
                    ? (maxValor / 4).ceilToDouble()
                    : 10,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.shade300, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == maxValor * 1.2)
                        return const Text('');
                      return Text(
                        "${value.toInt()}",
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= dias.length)
                        return const Text('');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          dias[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(
                dias.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: valores[index],
                      color: Colors.deepOrange, // Mesma cor do seu tema
                      width: 16, // Largura da barra
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      // Opcional: Adiciona um fundo cinza claro atrás da barra
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxValor * 1.2,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
