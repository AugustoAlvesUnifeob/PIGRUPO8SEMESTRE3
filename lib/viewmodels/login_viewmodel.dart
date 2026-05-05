import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/viewmodels(firebase_auth)/auth_services.dart';

class LoginViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  String? emailValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Email é obrigatório'),
      Validatorless.email('Digite um email válido'),
    ])(value);
  }

  String? passwordValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Senha é obrigatório'),
      Validatorless.min(6, 'A senha deve ter pelo menos 6 caracteres'),
    ])(value);
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    final query = await FirebaseFirestore.instance
    .collection('usuarios')
    .where('email', isEqualTo: emailController.text.trim())
    .limit(1)
    .get();

    if (query.docs.isEmpty) {
      // usuário não existe
      return;
    }

    final userDoc = query.docs.first;
    final data = userDoc.data();

    final bloqueadoAte = (data['bloqueadoAte'] as Timestamp?)?.toDate();

    if (bloqueadoAte != null && DateTime.now().isBefore(bloqueadoAte)) {
      final restante = bloqueadoAte.difference(DateTime.now()).inMinutes;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tente novamente em $restante minutos')),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      await authService.value.signIn(email: email, password: password);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .update({
        'tentativasLogin': 0,
        'bloqueadoAte': null,
      });

      isLoading = false;
      notifyListeners();
      await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .update({
        'ultimoLogin': Timestamp.now(),
      });
      Navigator.pushNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      String message;

      final tentativas = (data['tentativasLogin'] ?? 0) + 1;

      if (tentativas >= 5) {
        final bloqueio = DateTime.now().add(Duration(minutes: 5));

        await userDoc.reference.update({
          'tentativasLogin': 0,
          'bloqueadoAte': bloqueio,
        });
      } else {
        await userDoc.reference.update({
          'tentativasLogin': tentativas,
        });
      }

      if (e.code == 'user-not-found') {
        message = 'Email não encontrado';
      } else if (e.code == 'wrong-password') {
        message = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        message = 'Email inválido';
      } else {
        message = 'Erro ao fazer login';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao fazer login')));
    }
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
}
