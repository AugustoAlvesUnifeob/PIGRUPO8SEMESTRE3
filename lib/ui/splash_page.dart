import 'dart:async';
import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/viewmodels(firebase_auth)/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  Future<void> _verificarUsuario() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = authService.value.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (!doc.exists || doc.data()?['ultimoLogin'] == null) {
        // Se não tiver campo, manda logar de novo
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        return;
      }

      final Timestamp ultimoLogin = doc['ultimoLogin'];
      final dataUltimoLogin = ultimoLogin.toDate();

      final diferenca = DateTime.now().difference(dataUltimoLogin).inDays;

      if (diferenca >= 90) {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),

            Center(
              child: Column(
                children: [
                  Image.asset("lib/assets/maquina.png", height: 250),
                  const SizedBox(height: 20),
                  Image.asset("lib/assets/pbtexto.png", height: 40),
                ],
              ),
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}