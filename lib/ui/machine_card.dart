import 'package:flutter/material.dart';
import 'package:PIGRUPO8SEMESTRE3main/models/machinemodel.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/dashboard/status_badge.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/dashboard/progressMeta.dart';

class MachineCard extends StatelessWidget {
  final MachineModel machine;
  final bool showPecasCortadas;

  const MachineCard({
    super.key,
    required this.machine,
    this.showPecasCortadas = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.nome,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                StatusBadge(isActive: machine.isOperando),
              ],
            ),
            const SizedBox(height: 8),
            // Tempo ativo
            Text('TEMPO ATIVO: ${machine.tempoAtivo} MIN'),
            const SizedBox(height: 12),
            // Se for máquina de corte, mostra peças cortadas e gráfico/meta
            if (showPecasCortadas) ...[
              Text('Peças Cortadas: ${machine.pecasCortadas}'),
              const SizedBox(height: 8),
              // Placeholder para gráfico de produção
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('Produção nas últimas horas'),
                ),
              ),
              const SizedBox(height: 8),
              ProgressMeta(progress: machine.metaProgress),
              const SizedBox(height: 8),
            ],
            // Botões de ação
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _onDefinirMeta(context),
                  icon: const Icon(Icons.flag, size: 18),
                  label: const Text('Definir Nova Meta'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _onReiniciarContagem(context),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reiniciar Contagem'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _onConfigurarESP32(context),
                  icon: const Icon(Icons.settings_input_antenna, size: 18),
                  label: const Text('Configurar ESP32'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _onHistorico(context),
                  icon: const Icon(Icons.history, size: 18),
                  label: const Text('Histórico de Anomalias'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onDefinirMeta(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Definir meta para ${machine.nome}'),
        content: const Text('Funcionalidade em desenvolvimento'), 
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onReiniciarContagem(BuildContext context) {
    //feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contagem de ${machine.nome} reiniciada!')),
    );
  }

  void _onConfigurarESP32(BuildContext context) {
    //configuração ESP32
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Configurar ESP32 - ${machine.nome}'),
        content: const Text('Funcionalidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onHistorico(BuildContext context) {
    //navegar para histórico da máquina
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Histórico de Anomalias - ${machine.nome}'),
        content: const Text('Nenhuma anomalia registrada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}