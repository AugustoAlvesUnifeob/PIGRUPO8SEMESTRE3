import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:PIGRUPO8SEMESTRE3main/firebase_options.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/viewmodels(firebase_auth)/auth_services.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthServices auth;

  setUpAll(() async {

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    auth = AuthServices();

    print('FIREBASE PASSOU');
  });

  group('AuthServices Tests', () {

    test('TC01 — Criar conta', () async {
      print('RODOU TESTE');

      final email =
          'teste${DateTime.now().millisecondsSinceEpoch}@gmail.com';

      final result = await auth.createAccount(
        email: email,
        password: '123456',
      );

      expect(
        result.user,
        isNotNull,
      );
    });

    test('TC02 — Login válido', () async {
      print('RODOU TESTE');

      final email =
          'teste${DateTime.now().millisecondsSinceEpoch}@gmail.com';

      await auth.createAccount(
        email: email,
        password: '123456',
      );

      await auth.signOut();

      final result = await auth.signIn(
        email: email,
        password: '123456',
      );

      expect(
        result.user,
        isNotNull,
      );
    });

    test('TC03 — Senha inválida', () async {
      print('RODOU TESTE');

      final email =
          'teste${DateTime.now().millisecondsSinceEpoch}@gmail.com';

      await auth.createAccount(
        email: email,
        password: '123456',
      );

      await auth.signOut();

      expect(
        () async => await auth.signIn(
          email: email,
          password: '999999',
        ),
        throwsException,
      );
    });

    test('TC04 — Logout', () async {
      print('RODOU TESTE');

      final email =
          'teste${DateTime.now().millisecondsSinceEpoch}@gmail.com';

      await auth.createAccount(
        email: email,
        password: '123456',
      );

      await auth.signOut();

      expect(
        auth.currentUser,
        null,
      );
    });

    test('TC05 — Reset password', () async {
      print('RODOU TESTE');

      final email =
          'teste${DateTime.now().millisecondsSinceEpoch}@gmail.com';

      await auth.createAccount(
        email: email,
        password: '123456',
      );

      await auth.resetPassword(
        email: email,
      );

      expect(
        true,
        true,
      );
    });
  });
}