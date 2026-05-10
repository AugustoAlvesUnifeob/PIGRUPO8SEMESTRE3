import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/viewmodels(firebase_auth)/auth_services.dart';

class RegisterViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  String? nomeValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('nome é obrigatório'),
      Validatorless.min(3, 'O nome deve ter pelo menos 3 caracteres'),
    ])(value);
  }

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

  String? confirmValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('Confirmação de senha é obrigatória'),
      Validatorless.compare(passwordController, 'As senhas não coincidem'),
    ])(value);
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<String?> register() async {
    if (!formKey.currentState!.validate()) {
      return "form_error";
    }

    isLoading = true;
    notifyListeners();

    try {
      final nome = nomeController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      final credential = await authService.value.createAccount(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'nome': nome,
          'email': email,
          'idSensor': '',
          'uid': uid,
        });
      }

      isLoading = false;
      notifyListeners();
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.code == 'email-already-in-use') {
        return "Email já cadastrado";
      } else if (e.code == 'invalid-email') {
        return "Email inválido";
      } else if (e.code == 'weak-password') {
        return "Senha muito fraca";
      }

      return "Erro ao cadastrar usuário";
    } catch (_) {
      isLoading = false;
      notifyListeners();
      return "Erro ao cadastrar usuário";
    }
  }

  Future<String?> alterar(String oldEmail) async {
    if (!formKey.currentState!.validate()) {
      return "form_error";
    }

    isLoading = true;
    notifyListeners();
    
    
    try {
      final user = FirebaseAuth.instance.currentUser;

      if(user == null){
        return "Usuário não autenticado";
      }
      
      final password = passwordController.text;
      final nome = nomeController.text.trim()!;
      final email = emailController.text.trim();  

      final cred = EmailAuthProvider.credential(
        email: oldEmail,
        password: password
      );

      await user.reauthenticateWithCredential(cred);

      if(email != oldEmail)
      {
        await user.verifyBeforeUpdateEmail(email);
      }
      
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim(),
      });

      isLoading = false;
      notifyListeners();
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.code == 'invalid-email') {
        return "Email inválido";
      }

      return "Erro ao altear usuário";
    } catch (_) {
      isLoading = false;
      notifyListeners();
      return "Erro ao alterar usuário";
    }
  }

  Future<void> recuperarSenha(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      print('E-mail de recuperação enviado!');
    } on FirebaseAuthException catch (e) {
      print('Erro: ${e.message}');
    }
  }
}
