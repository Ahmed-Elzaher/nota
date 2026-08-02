import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/features/main_layout/presentation/screen/main_layout_screen.dart';
import 'package:nota/features/splash/presentation/screen/splash_screen.dart';
import 'package:nota/features/settings/presentation/screen/settings_screen.dart';
import 'package:nota/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/features/items/presentation/screen/add_item_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterPath.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouterPath.home:
        return MaterialPageRoute(builder: (context) => const MainLayoutScreen());
      case RouterPath.settings:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      case RouterPath.addItem:
        final initialContent = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<ItemsCubit>(),
            child: AddItemScreen(initialContent: initialContent),
          ),
        );
      case RouterPath.notifications:
        return MaterialPageRoute(builder: (context) => const NotificationsScreen());
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

