import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/core/settings/app_settings_cubit.dart';
import 'package:nota/core/settings/app_settings_state.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _prefs = getIt<SharedPreferences>();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await _prefs.setBool('notifications_enabled', value);
    // In a real app, you would enable/disable the actual daily notification here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final isDark = state.themeMode == ThemeMode.dark;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'الحساب'),
              ListTile(
                leading: const HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, color: Colors.grey, size: 28),
                title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('تعديل بيانات الحساب'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(),
              _buildSectionHeader(context, 'الإعدادات العامة'),
              SwitchListTile(
                title: Text(context.l10n.notificationsAndDailyReminder, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(context.l10n.receiveNotificationsToRemindYou),
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeThumbColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade800,
                secondary: const HugeIcon(icon: HugeIcons.strokeRoundedNotification01, color: Colors.grey, size: 28),
              ),
              const Divider(),
              ListTile(
                leading: const HugeIcon(icon: HugeIcons.strokeRoundedLanguageCircle, color: Colors.grey, size: 28),
                title: Text(context.l10n.appLanguage, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(context.l10n.choosePreferredLanguage),
                trailing: DropdownButton<String>(
                  value: state.locale.languageCode,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'ar', child: Text(context.l10n.arabic)),
                    DropdownMenuItem(value: 'en', child: Text(context.l10n.english)),
                  ],
                  onChanged: (lang) {
                    if (lang != null) {
                      context.read<AppSettingsCubit>().changeLanguage(lang);
                    }
                  },
                ),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(context.l10n.themeMode, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(isDark ? context.l10n.darkTheme : context.l10n.lightMode),
                value: isDark,
                onChanged: (val) {
                  context.read<AppSettingsCubit>().toggleTheme(val);
                },
                activeThumbColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade800,
                secondary: HugeIcon(
                  icon: isDark ? HugeIcons.strokeRoundedMoon02 : HugeIcons.strokeRoundedSun01,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
              const Divider(),
              _buildSectionHeader(context, 'أخرى'),
              ListTile(
                leading: const HugeIcon(icon: HugeIcons.strokeRoundedInformationCircle, color: Colors.grey, size: 28),
                title: const Text('عن التطبيق', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('الإصدار 1.0.0'),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
