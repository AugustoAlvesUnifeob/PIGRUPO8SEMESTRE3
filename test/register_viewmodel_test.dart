import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/register_viewmodel.dart';

void main() {
  late RegisterViewmodel viewModel;

  setUp(() {
    viewModel = RegisterViewmodel();
  });

  group('RegisterViewmodel - Testes', () {

    // VALIDATORS

    test('TC01 — Nome vazio', () {

      final result = viewModel.nomeValidator("");

      expect(
        result,
        'nome é obrigatório',
      );
    });

    test('TC02 — Nome menor que 3 caracteres', () {

      final result = viewModel.nomeValidator("ab");

      expect(
        result,
        'O nome deve ter pelo menos 3 caracteres',
      );
    });

    test('TC03 — Nome válido', () {

      final result = viewModel.nomeValidator("Marcelo");

      expect(
        result,
        null,
      );
    });

    test('TC04 — Email vazio', () {

      final result = viewModel.emailValidator("");

      expect(
        result,
        'Email é obrigatório',
      );
    });

    test('TC05 — Email inválido', () {

      final result = viewModel.emailValidator("marceloemail.com");

      expect(
        result,
        'Digite um email válido',
      );
    });

    test('TC06 — Email válido', () {

      final result = viewModel.emailValidator(
        "marcelo@email.com",
      );

      expect(
        result,
        null,
      );
    });

    test('TC07 — Senha vazia', () {

      final result = viewModel.passwordValidator("");

      expect(
        result,
        'Senha é obrigatório',
      );
    });

    test('TC08 — Senha curta', () {

      final result = viewModel.passwordValidator("123");

      expect(
        result,
        'A senha deve ter pelo menos 6 caracteres',
      );
    });

    test('TC09 — Senha válida', () {

      final result = viewModel.passwordValidator("123456");

      expect(
        result,
        null,
      );
    });

    test('TC10 — Confirmação vazia', () {

      viewModel.passwordController.text = "123456";

      final result = viewModel.confirmValidator("");

      expect(
        result,
        'Confirmação de senha é obrigatória',
      );
    });

    test('TC11 — Senhas diferentes', () {

      viewModel.passwordController.text = "123456";

      final result = viewModel.confirmValidator("654321");

      expect(
        result,
        'As senhas não coincidem',
      );
    });

    test('TC12 — Confirmação válida', () {

      viewModel.passwordController.text = "123456";

      final result = viewModel.confirmValidator("123456");

      expect(
        result,
        null,
      );
    });

    // TOGGLE DA PASSWORD

    test('TC13 — Toggle password visibility', () {

      final initial = viewModel.obscurePassword;

      viewModel.togglePasswordVisibility();

      expect(
        viewModel.obscurePassword,
        !initial,
      );
    });

    test('TC14 — Toggle confirm visibility', () {

      final initial = viewModel.obscureConfirm;

      viewModel.toggleConfirmVisibility();

      expect(
        viewModel.obscureConfirm,
        !initial,
      );
    });
  });
}