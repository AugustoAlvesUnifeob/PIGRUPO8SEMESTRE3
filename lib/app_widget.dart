import 'package:flutter/material.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


class AppWidget extends StatelessWidget {  
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'PACKBAG - Máquina de Corte',
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
    );
  }
}
