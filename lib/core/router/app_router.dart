import 'package:flutter/material.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/features/home/presentation/screens/home_screen.dart';
import 'package:nota/features/splash/presentation/screens/splash_screen.dart';
import 'package:nota/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterPath.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouterPath.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouterPath.settings:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Path not found'),
            ),
          ),
        );
    }
  }
}
