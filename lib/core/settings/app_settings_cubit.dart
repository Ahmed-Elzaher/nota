import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final SharedPreferences _prefs;

  AppSettingsCubit(this._prefs)
      : super(AppSettingsState(
          themeMode: _loadThemeMode(_prefs),
          locale: _loadLocale(_prefs),
        ));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final isDark = prefs.getBool('is_dark_mode');
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Locale _loadLocale(SharedPreferences prefs) {
    final langCode = prefs.getString('language');
    if (langCode != null) {
      return Locale(langCode);
    }
    // Default to arabic
    return const Locale('ar');
  }

  Future<void> toggleTheme(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> changeLanguage(String langCode) async {
    await _prefs.setString('language', langCode);
    emit(state.copyWith(locale: Locale(langCode)));
  }
}
