import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/router/app_router.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/core/theme/app_themes.dart';
import 'package:nota/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermissions();
  await NotificationService.instance.scheduleDailyMotivation();
  await setUpLocators();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nota',
          theme: AppThemes.lightTheme,
          onGenerateRoute: AppRouter().onGenerateRoute,
          initialRoute: RouterPath.splash,
        );
      },
    );
  }
}
