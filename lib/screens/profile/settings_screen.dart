import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxury_restaurant_app/theme/theme_provider.dart';
import 'package:luxury_restaurant_app/main.dart'; // To access languageNotifier
import '../../models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/flutter_tts_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool ttsEnabled = false;
  final TTSService _ttsService = TTSService.instance;

  @override
  void initState() {
    super.initState();
    _ttsService.init().then((_) {
      setState(() {
        ttsEnabled = _ttsService.isEnabled;
      });
    });
  }

  Future<void> _toggleTTS(bool value) async {
    await _ttsService.toggle(value);
    setState(() {
      ttsEnabled = value;
    });
    if (value && mounted) {
      await _ttsService.setLanguage(AppData.selectedLanguage);
      await _ttsService.speak(
        AppData.trans('tts_preview_text') ?? "Text to speech enabled",
      );
    }
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppData.trans('logout'),
            style: const TextStyle(fontFamily: 'serif')),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              }
            },
            child: Text(AppData.trans('logout'),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppData.trans('languages'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        languageNotifier.value = code;
        AppData.selectedLanguage = code;
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppData.trans('Settings'),
            style: const TextStyle(
                fontFamily: 'serif', fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.language,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(AppData.trans('Select Language'),
                  style: const TextStyle(
                      fontFamily: 'serif', fontWeight: FontWeight.w600)),
              subtitle: Text(AppData.selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showLanguageDialog,
            ),
          ),

          // Dark mode toggle
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProv, child) {
                return SwitchListTile(
                  secondary: Icon(Icons.dark_mode,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(AppData.trans('Dark Mode'),
                      style: const TextStyle(
                          fontFamily: 'serif', fontWeight: FontWeight.w600)),
                  value: themeProv.mode! == ThemeMode.dark,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    themeProv.mode = value ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),

          // TTS toggle
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(Icons.volume_up_outlined,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(AppData.trans('Enable Text-to-Speech'),
                  style: const TextStyle(
                      fontFamily: 'serif', fontWeight: FontWeight.w600)),
              subtitle: Text(
                AppData.trans('tts_subtitle') ??
                    'Uses your device\'s accessibility TTS settings',
                style: const TextStyle(fontSize: 12),
              ),
              value: ttsEnabled,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: _toggleTTS,
            ),
          ),

          // Notifications toggle
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(AppData.trans('Turn on notifications'),
                  style: const TextStyle(
                      fontFamily: 'serif', fontWeight: FontWeight.w600)),
              value: pushNotifications,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Logout Section
          _buildSettingsCard(
            icon: Icons.logout,
            title: AppData.trans('Logout'),
            subtitle: AppData.trans('Sign out of your account'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  // Helper widget
  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon,
            color: isDestructive
                ? Colors.red
                : Theme.of(context).colorScheme.primary),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'serif', fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
