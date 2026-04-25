// ignore_for_file: file_names

class MachineModel {
  final String id;
  final String nome;
  final bool isOperando;
  final int tempoAtivo;
  final int pecasCortadas;
  final double metaProgress;

  MachineModel({
    required this.id,
    required this.nome,
    required this.isOperando,
    required this.tempoAtivo,
    required this.pecasCortadas,
    required this.metaProgress,
  });
}