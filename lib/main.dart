import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/router/app_router.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/core/theme/app_themes.dart';
import 'package:nota/core/services/notification_service.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/l10n/app_localizations.dart';
import 'package:nota/core/settings/app_settings_cubit.dart';
import 'package:nota/core/settings/app_settings_state.dart';

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
    return BlocProvider.value(
      value: getIt<AppSettingsCubit>(),
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (context) => context.l10n.appName,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ar'),
                  Locale('en'),
                ],
                locale: state.locale,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: state.themeMode,
                themeAnimationDuration: Duration.zero,
                onGenerateRoute: AppRouter().onGenerateRoute,
                initialRoute: RouterPath.splash,
              );
            },
          );
        },
      ),
    );
  }
}
