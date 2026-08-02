import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class AppSettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
  });

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
