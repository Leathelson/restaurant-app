import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/main.dart'; // IMPORTANT for languageNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color _maroon = Color(0xFF63210B);
  static const Color _gold = Color(0xFFB37C1E);
  static const Color _darkPurple = Color(0xFF34495E);

  bool _notificationsEnabled = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppData.trans('settings'),
              style: const TextStyle(
                  color: _maroon, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildMainSettingsCard(),
              const SizedBox(height: 20),
              _buildMenuPill(
                title: AppData.trans('languages'),
                icon: Icons.translate,
                color: _gold,
                onTap: () => _showLanguageDialog(),
              ),
              const SizedBox(height: 15),
              _buildMenuPill(
                title: AppData.trans('log_out'),
                icon: Icons.logout,
                color: _gold,
                onTap: () => _handleLogout(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: _darkPurple, borderRadius: BorderRadius.circular(35)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppData.trans('general_settings'),
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/profile.png')),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('William Dafuq',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(AppData.trans('edit_profile'),
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              )
            ],
          ),
          const Divider(color: Colors.white24, height: 35),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppData.trans('account_settings'),
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          _buildToggleRow(
              AppData.trans('push_notification'),
              _notificationsEnabled,
              (v) => setState(() => _notificationsEnabled = v)),
          _buildToggleRow(AppData.trans('dark_mode'), _darkMode,
              (v) => setState(() => _darkMode = v)),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          Switch(
              value: value,
              onChanged: onChanged,
              activeColor: _gold,
              activeTrackColor: _gold.withOpacity(0.4)),
        ],
      ),
    );
  }

  Widget _buildMenuPill(
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 20),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppData.trans('log_out'),
            style:
                const TextStyle(color: _maroon, fontWeight: FontWeight.bold)),
        content: Text(AppData.trans('logout_confirm')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppData.trans('cancel'),
                  style: const TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () async {
              await auth.FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: Text(AppData.trans('log_out'),
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppData.trans('languages'),
            style: const TextStyle(color: _maroon)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption('English', 'en'),
            _langOption('Español', 'es'),
            _langOption('Français', 'fr'),
          ],
        ),
      ),
    );
  }

  Widget _langOption(String name, String code) {
    return ListTile(
      title: Text(name),
      trailing: AppData.selectedLanguage == code
          ? const Icon(Icons.check, color: _gold)
          : null,
      onTap: () {
        languageNotifier.value = code; // This triggers the main.dart rebuild
        AppData.selectedLanguage = code;
        Navigator.pop(context);
        setState(() {});
      },
    );
  }
}
