import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAPm_PiG-fyLRowwsow64CnpMXaXuuZL58",
      appId: "1:1009098230037:android:3b1de1425f64add708011c",
      messagingSenderId: "1009098230037",
      projectId: "pi-grupo8",
    ),
  );
  runApp(AppWidget());
}
