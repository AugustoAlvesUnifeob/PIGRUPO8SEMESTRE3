import 'package:flutter/material.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/maquina.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:PIGRUPO8SEMESTRE3main/app_widget.dart'; // importa o routeObserver

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late Stream<String?> _nomeStream;
  late Stream<bool?> _estadoStream;

  String getDataFormatada() {
    final now = DateTime.now();
    return DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(now);
  }

  void _iniciarStreams() {
    _nomeStream = streamNomeMaquina();
    _estadoStream = streamEstadoMaquina();
  }

  @override
  void initState() {
    super.initState();
    _iniciarStreams();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _iniciarStreams();
    });
  }

  Future<void> PoliticaPriv() async {
    final Uri url = Uri.parse('https://packbag.com.br/politica-de-privacidade');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
        title: Image.asset(AppColors.logo, width: 160, height: 80),
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
            child: Icon(Icons.accessibility, size: 28, color: AppColors.preto),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bem-vindo(a)!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.preto,
                    ),
                  ),
                  Text(
                    getDataFormatada(),
                    style: TextStyle(fontSize: 13, color: AppColors.pretoClaro),
                  ),

                  const SizedBox(height: 20),

                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                        decoration: BoxDecoration(
                          color: AppColors.cinzaClaro,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Visualize seus dispositivos e monitore cada um deles.\n"
                          "Receba estimativas e previsões de produção.\n\n"
                          "Verifique o estado do dispositivo se está ativo ou não.",
                          style: TextStyle(fontSize: 14, color: AppColors.preto),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cinza,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Visualização Inteligente",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.preto,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.lightbulb,
                                color: AppColors.amarelo,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Icon(
                      Icons.arrow_downward,
                      size: 28,
                      color: AppColors.preto,
                    ),
                  ),

                  const SizedBox(height: 25),

                  StreamBuilder<bool?>(
                    stream: _estadoStream,
                    builder: (context, estadoSnapshot) {
                      final bool ativo = estadoSnapshot.data ?? false;

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
                                StreamBuilder<String?>(
                                  stream: _nomeStream,
                                  builder: (context, nomeSnapshot) {
                                    final String nome =
                                        (nomeSnapshot.hasData &&
                                                nomeSnapshot.data!.isNotEmpty)
                                            ? nomeSnapshot.data!
                                            : "Máquina de Corte";
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

                                Text(
                                  ativo ? "OPERANDO" : "PARADO",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ativo ? Colors.green : Colors.red,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "ESP32: CONECTADO",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.preto,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'lib/assets/esp32.png',
                                      width: 70,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.preto,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.machine,
                                        );
                                      },
                                      child: Text(
                                        "VISUALIZAR",
                                        style: TextStyle(
                                          color: AppColors.branco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: ativo ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.sensores);
                    },
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.cinzaClaro,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 28, color: AppColors.preto),
                          const SizedBox(width: 8),
                          Text(
                            "OUTROS DISPOSITIVOS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.preto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _bottomButton(Icons.settings, "Configurações", () {
                        Navigator.pushNamed(context, AppRoutes.settings);
                      }),
                      _bottomButton(Icons.person, "Usuário", () {
                        Navigator.pushNamed(context, AppRoutes.user);
                      }),
                    ],
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.preto,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.sobre);
                    },
                    child: Text(
                      "SOBRE",
                      style: TextStyle(
                        color: AppColors.branco,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: Colors.black,
              child: Column(
                children: [
                  Image.asset(AppColors.logop, height: 60),
                  const SizedBox(height: 10),
                  Text(
                    "PACKBAG",
                    style: TextStyle(
                      color: AppColors.contraste
                          ? AppColors.preto
                          : AppColors.branco,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => PoliticaPriv(),
                    child: Text(
                      "Política de privacidade",
                      style: TextStyle(color: AppColors.laranja, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "© 2026 Pack Bag. Criado com carinho por Agência O3 Propaganda",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.contraste
                          ? AppColors.preto
                          : AppColors.cinza,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bottomButton(
    IconData icon,
    String text,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cinzaClaro,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: onPressed,
          child: Column(
            children: [
              Icon(icon, color: AppColors.preto),
              const SizedBox(height: 5),
              Text(text, style: TextStyle(color: AppColors.preto)),
            ],
          ),
        ),
      ),
    );
  }
}