import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> irParaPackbag() async {
    final Uri url = Uri.parse('https://packbag.com.br/contato/');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    } else {
      throw Exception('Não foi possível abrir $url');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> PoliticaPriv() async {
    final Uri url = Uri.parse('https://packbag.com.br/politica-de-privacidade');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    } else {
      throw Exception('Não foi possível abrir $url');
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
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CONFIGURAÇÕES',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.preto,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Botão CONEXÕES
                    /*_settingsButton(
                      backgroundColor: AppColors.cinza,
                      label: 'CONEXÕES',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.sensores);
                      },
                    ),*/

                    const SizedBox(height: 16),

                    // Botão SUPORTE
                    _settingsButton(
                      backgroundColor: AppColors.cinza,
                      label: 'SUPORTE',
                      onTap: () {
                        irParaPackbag();
                      },
                    ),

                    const SizedBox(height: 16),

                    // Botão REINICIAR APLICATIVO
                    _settingsButton(
                      backgroundColor: AppColors.cinza,
                      label: 'REINICIAR APLICATIVO',
                      onTap: () {
                        Restart.restartApp();
                      },
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                    onTap: () {
                      PoliticaPriv();
                    },
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

  Widget _settingsButton({
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cinza,
          borderRadius: BorderRadius.circular(8),
          border: AppColors.contraste
              ? Border.all(color: AppColors.preto, width: 2)
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.preto,
          ),
        ),
      ),
    );
  }
}
