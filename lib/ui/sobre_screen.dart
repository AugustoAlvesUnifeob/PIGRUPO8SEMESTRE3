import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();

  Future<void> PoliticaPriv() async {
    final Uri url = Uri.parse('https://packbag.com.br/politica-de-privacidade');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    } else {
      throw Exception('Não foi possível abrir $url');
    }
  }
}

class _SobreScreenState extends State<SobreScreen> {
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
                    // ── Título ──────────────────────────────────────────
                    Text(
                      'SOBRE:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.preto,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Card: O Projeto ─────────────────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(Icons.info_outline, 'O PROJETO'),
                          const SizedBox(height: 10),
                          Text(
                            'Protótipo de interface gráfica desenvolvido como projeto '
                            'acadêmico integrador. O aplicativo PackBag tem como objetivo '
                            'facilitar o monitoramento inteligente de dispositivos industriais, '
                            'oferecendo visualização de sensores em tempo real.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.preto,
                              height: 1.65,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _chip('Protótipo'),
                              const SizedBox(width: 8),
                              _chip('2026'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Card: Integrantes do Projeto ─────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            Icons.group_outlined,
                            'INTEGRANTES DO PROJETO',
                          ),
                          const SizedBox(height: 12),
                          _memberRow(
                            'Augusto Barreto Gomes Alves',
                            'Backend & Integração com FirebaseAuth e IoT',
                          ),
                          _divider(),
                          _memberRow(
                            'Mateus Graçadio Coelho',
                            'Arquitetura de Fluxos & Documentação',
                          ),
                          _divider(),
                          _memberRow(
                            'Pedro Henrique Breda Domingues',
                            'Frontend – Telas do Dashboard e Visualizações',
                          ),
                          _divider(),
                          _memberRow(
                            'Felipe Grossi Pereira',
                            'Frontend – Telas de Autenticação e Usuário',
                          ),
                          _divider(),
                          _memberRow(
                            'João Vitor Zamai Martins',
                            'Backend & Integração de Gráficos',
                          ),
                          _divider(),
                          _memberRow(
                            'Augusto de Pauli Duarte',
                            'Frontend – Outras Telas do Aplicativo',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Card: Tecnologias ────────────────────────────────
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(Icons.code, 'TECNOLOGIAS'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _techChip(Icons.flutter_dash, 'Flutter'),
                              _techChip(Icons.storage, 'Firebase'),
                              _techChip(Icons.memory, 'ESP32'),
                              _techChip(Icons.wifi, 'IoT'),
                              _techChip(Icons.lock_outline, 'Firebase Auth'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Card: Instituição ────────────────────────────────
                    _sectionCard(
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.cinzaClaro,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.school_outlined,
                              color: AppColors.preto,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UNIFEOB',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.preto,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Centro Universitário da Fundação de Ensino Octávio Bastos',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.pretoClaro,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Rodapé estilo Figma ──────────────────────────────
                    _rodapeFigma(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Rodapé preto (padrão do projeto) ───────────────────────
            Container(height: 30, color: AppColors.preto),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cinzaClaro2,
        borderRadius: BorderRadius.circular(14),
        border: AppColors.contraste
            ? Border.all(color: AppColors.preto, width: 2)
            : Border.all(color: AppColors.cinzaClaro, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.pretoClaro,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.laranja),
        const SizedBox(width: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.preto,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _memberRow(String name, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cinzaClaro,
            ),
            child: Icon(Icons.person_outline, size: 19, color: AppColors.preto),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.preto,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(fontSize: 11, color: AppColors.pretoClaro),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppColors.cinzaClaro);

  Widget _rodapeFigma() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cinzaClaro2,
        border: Border(top: BorderSide(color: AppColors.cinzaClaro, width: 1)),
      ),
      child: Column(
        children: [
          // Logo PackBag real
          Image.asset(
            AppColors.logo,
            key: ValueKey(AppColors.logo),
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 14),
          // Texto descritivo
          Text(
            'Desde 2011 no mercado, a PACK BAG é hoje uma das maiores e '
            'mais fortes fabricantes de Big Bags do Brasil. Nossos '
            'colaboradores trabalham motivados para atender às expectativas '
            'de todas as empresas que confiam em nós para oferecer produtos '
            'de qualidade, dentro do prazo e com atendimento especializado.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.pretoClaro,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          // Política de privacidade
          Text(
            'Política de privacidade',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.laranja,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.laranja,
            ),
          ),
          const SizedBox(height: 16),
          // Divider
          Divider(color: AppColors.cinzaClaro, height: 1),
          const SizedBox(height: 12),
          // Copyright
          Text(
            '© 2026 Pack Bag. Criado com carinho por Agência G3 Propaganda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: AppColors.pretoClaro),
          ),
        ],
      ),
    );
  }

  Widget _techChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cinzaClaro,
        borderRadius: BorderRadius.circular(20),
        border: AppColors.contraste
            ? Border.all(color: AppColors.preto, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.laranja),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.preto,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cinzaClaro,
        borderRadius: BorderRadius.circular(12),
        border: AppColors.contraste
            ? Border.all(color: AppColors.preto, width: 1)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.pretoClaro,
        ),
      ),
    );
  }
}
