import 'package:PIGRUPO8SEMESTRE3main/ui/CadastroSensor_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/altSensor_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/maquina_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/recuperarScreen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/sensor_list_page.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/login_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/cadastro_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/splash_page.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/home_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/user_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/sobre_screen.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/alterar_screen.dart';

abstract class AppPages {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const CadastroScreen(),
    AppRoutes.home: (_) => const HomePage(),
    AppRoutes.splash: (_) => const SplashPage(),
    AppRoutes.machine: (_) => const MachineScreen(),
    AppRoutes.settings: (_) => const SettingsScreen(),
    AppRoutes.sobre: (_) => const SobreScreen(),
    AppRoutes.user: (_) => const UserScreen(),
    AppRoutes.alterar: (_) => const AlterarScreen(),
    AppRoutes.sensores: (_) => const SensorListPage(),
    AppRoutes.cadsensores: (_) => const CadSensorScreen(),
    AppRoutes.altsensores: (_) => const AltSensorScreen(),
    AppRoutes.recuperar: (_) => const RecuperarScreen(),
  };
}
