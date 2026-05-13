import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/login_viewmodel.dart';

void main() {
  late LoginViewmodel viewModel;

  setUp(() {
    viewModel = LoginViewmodel();
  });

  group('LoginViewmodel - Testes', () {

    // VALIDATORS

    test('TC01 — Email vazio', () {

      final result = viewModel.emailValidator("");

      expect(
        result,
        'Email é obrigatório',
      );
    });

    test('TC02 — Email inválido', () {

      final result = viewModel.emailValidator(
        "marceloemail.com",
      );

      expect(
        result,
        'Digite um email válido',
      );
    });

    test('TC03 — Email válido', () {

      final result = viewModel.emailValidator(
        "marcelo@email.com",
      );

      expect(
        result,
        null,
      );
    });

    test('TC04 — Senha vazia', () {

      final result = viewModel.passwordValidator("");

      expect(
        result,
        'Senha é obrigatório',
      );
    });

    test('TC05 — Senha curta', () {

      final result = viewModel.passwordValidator(
        "123",
      );

      expect(
        result,
        'A senha deve ter pelo menos 6 caracteres',
      );
    });

    test('TC06 — Senha válida', () {

      final result = viewModel.passwordValidator(
        "123456",
      );

      expect(
        result,
        null,
      );
    });

    // CONTROLLERS

    test('TC10 — Controllers recebem valores', () {

      viewModel.emailController.text =
          "marcelo@email.com";

      viewModel.passwordController.text =
          "123456";

      expect(
        viewModel.emailController.text,
        "marcelo@email.com",
      );

      expect(
        viewModel.passwordController.text,
        "123456",
      );
    });

    // CHANGE NOTIFIER

    test('TC16 — notifyListeners ao alterar password',
        () {

      bool notified = false;

      viewModel.addListener(() {
        notified = true;
      });

      viewModel.togglePasswordVisibility();

      expect(
        notified,
        true,
      );
    });
  });
}