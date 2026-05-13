import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/cortes.dart';

void main() {
  late ContagemCortesService service;

  setUp(() {
    service = ContagemCortesService();
  });

  group('LogPHR.fromFirestore', () {
    test('deve criar objeto corretamente', () {
      final json = {
        'idSensor': 'S1',
        'leitura': 150,
        'lote': 10,
        'dataleitura': '2026-05-12',
        'horaleitura': '14:30:00',
      };

      final log = LogPHR.fromFirestore(json);

      expect(log.idSensor, 'S1');
      expect(log.leitura, 150);
      expect(log.lote, 10);
      expect(log.dataHora.year, 2026);
      expect(log.dataHora.hour, 14);
    });
  });

  group('calcularTotalPecas', () {
    test('deve somar corretamente as leituras', () {
      final logs = [
        LogPHR(
          idSensor: '1',
          leitura: 100,
          lote: 1,
          dataHora: DateTime.now(),
        ),
        LogPHR(
          idSensor: '2',
          leitura: 200,
          lote: 1,
          dataHora: DateTime.now(),
        ),
      ];

      final total = service.calcularTotalPecas(logs);

      expect(total, 300);
    });

    test('deve retornar 0 com lista vazia', () {
      final total = service.calcularTotalPecas([]);

      expect(total, 0);
    });
  });

  group('calcularPercentualMeta', () {
    test('deve calcular 50%', () {
      final percentual = service.calcularPercentualMeta(1000);

      expect(percentual, 0.5);
    });

    test('não deve ultrapassar 1.0', () {
      final percentual = service.calcularPercentualMeta(5000);

      expect(percentual, 1.0);
    });

    test('deve retornar 0 quando total for 0', () {
      final percentual = service.calcularPercentualMeta(0);

      expect(percentual, 0.0);
    });
  });

  group('gerarSpotsDoGrafico', () {
    test('deve agrupar leituras por hora', () {
      final logs = [
        LogPHR(
          idSensor: '1',
          leitura: 100,
          lote: 1,
          dataHora: DateTime(2026, 5, 12, 10, 0),
        ),
        LogPHR(
          idSensor: '2',
          leitura: 50,
          lote: 1,
          dataHora: DateTime(2026, 5, 12, 10, 30),
        ),
        LogPHR(
          idSensor: '3',
          leitura: 200,
          lote: 1,
          dataHora: DateTime(2026, 5, 12, 11, 0),
        ),
      ];

      final spots = service.gerarSpotsDoGrafico(logs);

      expect(spots.length, 2);

      expect(spots[0].x, 10);
      expect(spots[0].y, 150);

      expect(spots[1].x, 11);
      expect(spots[1].y, 200);
    });

    test('deve retornar lista vazia sem logs', () {
      final spots = service.gerarSpotsDoGrafico([]);

      expect(spots, isEmpty);
    });
  });
}