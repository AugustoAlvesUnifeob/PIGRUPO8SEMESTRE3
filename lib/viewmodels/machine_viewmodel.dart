import 'package:flutter/material.dart';

class MachineViewModel extends ChangeNotifier {
  final String id;
  final String nome;
  bool isOperando;
  int tempoAtivo;         // em minutos
  int pecasCortadas;
  double metaProgress;    // 0.0 a 1.0

  MachineViewModel({
    required this.id,
    required this.nome,
    this.isOperando = false,
    this.tempoAtivo = 0,
    this.pecasCortadas = 0,
    this.metaProgress = 0.0,
  });

  void reiniciarContagem() {
    pecasCortadas = 0;
    notifyListeners();
  }
}