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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildSectionHeader(context, 'الحساب والمزامنة'),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    title: 'الملف الشخصي',
                    subtitle: 'تعديل بيانات الحساب',
                    icon: HugeIcons.strokeRoundedUserCircle,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'المزامنة السحابية (Cloud Sync)',
                    subtitle: 'حفظ ملاحظاتك للوصول إليها من أي جهاز',
                    icon: HugeIcons.strokeRoundedCloudUpload,
                    iconColor: Theme.of(context).primaryColor,
                    trailing: _buildProBadge(context),
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'الخصوصية والأمان'),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    title: 'الخزنة السرية (Vault)',
                    subtitle: 'قفل ملاحظاتك المهمة بكلمة مرور أو بصمة',
                    icon: HugeIcons.strokeRoundedLockPassword,
                    trailing: _buildProBadge(context),
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'تخصيص التطبيق'),
              _buildSettingsCard(
                context: context,
                children: [
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
                      color: isDark ? Colors.amber : Colors.orange,
                      size: 28,
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const HugeIcon(icon: HugeIcons.strokeRoundedLanguageCircle, color: Colors.blue, size: 28),
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
                ],
              ),
              
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'التنبيهات'),
              _buildSettingsCard(
                context: context,
                children: [
                  SwitchListTile(
                    title: Text(context.l10n.notificationsAndDailyReminder, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(context.l10n.receiveNotificationsToRemindYou),
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeThumbColor: Theme.of(context).primaryColor,
                    inactiveThumbColor: Colors.grey.shade400,
                    inactiveTrackColor: Colors.grey.shade800,
                    secondary: const HugeIcon(icon: HugeIcons.strokeRoundedNotification01, color: Colors.redAccent, size: 28),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'أخرى'),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    title: 'مساعدة ودعم',
                    subtitle: 'تواصل معنا لحل المشاكل أو تقديم اقتراحات',
                    icon: HugeIcons.strokeRoundedCustomerService01,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'عن التطبيق',
                    subtitle: 'الإصدار 1.0.0 (Beta)',
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required BuildContext context, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required dynamic icon,
    Color? iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: HugeIcon(icon: icon, color: iconColor ?? Colors.grey, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, indent: 60);
  }

  Widget _buildProBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
