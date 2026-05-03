import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/maquina.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/cortes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/ai_service.dart';

class MachineScreen extends StatefulWidget {
  const MachineScreen({super.key});

  @override
  State<MachineScreen> createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
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
            colorScheme: ColorScheme.light(
              primary: AppColors.cinza, // Cor do header do DatePicker
              onPrimary: AppColors.preto, // Cor do texto do header
              onSurface: AppColors.preto, // Cor dos textos dos dias
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.cinza, // Cor dos botões "Cancelar" e "OK"
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
      });
    }
  }

  @override
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

          ElevatedButton(
            onPressed: () => _escolherData(context),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: AppColors.cinzaClaro,
            ),
            child: Icon(Icons.calendar_month, size: 30, color: AppColors.preto),
          ),
        ],
      ),

      body: StreamBuilder<List<LogPHR>>(
        stream: _service.getLogsPorData(_dataSelecionada),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.grey),
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

          final List<FlSpot> spotsGrafico = _service.gerarSpotsDoGrafico(logs);

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

                _buildGraficoHoras(spotsGrafico),
                const SizedBox(height: 24),

                // 2. Cards Superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildCardPecasCortadas(totalPecas),
                    _buildCardMeta(percentualMeta),
                  ],
                ),

                const SizedBox(height: 40),

                _buildAiInsightsSection(logs, _service.metaDiaria),
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
            color: AppColors.cinza,
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
                    "Insights da IA Gemini",
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
                children: [Image.asset('lib/assets/esp32.png', width: 70)],
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
            color: Colors.brown,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Peças Cortadas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '$totalPecas',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'META',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[300],
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
                  color: Colors.grey[800],
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

  Widget _buildGraficoHoras(List<FlSpot> spotsGrafico) {
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
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${value.toInt()}:00",
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
}
