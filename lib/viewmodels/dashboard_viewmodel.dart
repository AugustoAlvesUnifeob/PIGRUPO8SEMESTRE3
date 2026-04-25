import 'package:flutter/material.dart';
import 'package:PIGRUPO8SEMESTRE3main/models/machinemodel.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final DateTime _currentDate = DateTime.now();
  DateTime get currentDate => _currentDate;

  String get formattedDate {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${_currentDate.day} de ${months[_currentDate.month - 1]} de ${_currentDate.year}';
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    //simulação carregamento de dados.
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }



  List<MachineModel> machines = [];

  //carrega as máquinas mockada. Alterar depois para as informações das máquinas reais
  DashboardViewModel() {
    _loadMockMachines();
  }

  void _loadMockMachines() {
    machines = [
      MachineModel(
        id: 'corte',
        nome: 'Máquina de Corte',
        isOperando: true,
        tempoAtivo: 45,
        pecasCortadas: 60,
        metaProgress: 0.3,
      ),
      MachineModel(
        id: 'maq1',
        nome: 'Máquina 1',
        isOperando: true,
        tempoAtivo: 45,
        pecasCortadas: 0,
        metaProgress: 0.0,
      ),
      MachineModel(
        id: 'maq2',
        nome: 'Máquina 2',
        isOperando: true,
        tempoAtivo: 45,
        pecasCortadas: 0,
        metaProgress: 0.0,
      ),
      MachineModel(
        id: 'maq3',
        nome: 'Máquina 3',
        isOperando: true,
        tempoAtivo: 45,
        pecasCortadas: 0,
        metaProgress: 0.0,
      ),
    ];
  }

  //método futuro para carregar do Firebase
  Future<void> carregarDadosReais() async {
    _isLoading = true;
    notifyListeners();

    _isLoading = false;
    notifyListeners();
  }
}