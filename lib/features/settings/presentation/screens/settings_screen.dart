import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nota/core/di/di.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _prefs = getIt<SharedPreferences>();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
      _selectedLanguage = _prefs.getString('language') ?? 'ar';
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await _prefs.setBool('notifications_enabled', value);
    // In a real app, you would enable/disable the actual daily notification here
  }

  Future<void> _changeLanguage(String? lang) async {
    if (lang == null) return;
    setState(() => _selectedLanguage = lang);
    await _prefs.setString('language', lang);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سيتم تفعيل تغيير اللغة قريباً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SwitchListTile(
            title: const Text('الإشعارات والتذكير اليومي'),
            subtitle: const Text('تلقي إشعارات لتذكيرك بمراجعة مهامك'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: Theme.of(context).primaryColor,
          ),
          const Divider(),
          ListTile(
            title: const Text('لغة التطبيق'),
            subtitle: const Text('اختر لغتك المفضلة'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: _changeLanguage,
            ),
          ),
        ],
      ),
    );
  }
}
