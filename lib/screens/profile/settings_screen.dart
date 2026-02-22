import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/main.dart'; // To access languageNotifier
import '../../models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;

  // Consistency Colors
  final Color gold = Colors.amber;
  final Color darkBg = Colors.black87;

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppData.trans('language'),
            style: const TextStyle(fontFamily: 'serif')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French']
              .map(
                (lang) => RadioListTile<String>(
                  title:
                      Text(lang, style: const TextStyle(fontFamily: 'serif')),
                  value: lang,
                  groupValue: AppData.selectedLanguage,
                  activeColor: gold,
                  onChanged: (value) {
                    setState(() {
                      AppData.selectedLanguage = value!;
                      // Trigger app-wide rebuild
                      languageNotifier.value = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _editProfile() {
    final nameController =
        TextEditingController(text: AppData.currentUser.name);
    final emailController =
        TextEditingController(text: AppData.currentUser.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppData.trans('edit_profile'),
            style: const TextStyle(fontFamily: 'serif')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: gold),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: gold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: gold),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: gold)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppData.currentUser.name = nameController.text;
                AppData.currentUser.email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save',
                style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
            // Removed red, using gold/amber for consistency
            child: Text(AppData.trans('logout'),
                style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
          _buildSettingsCard(
            icon: Icons.language,
            title: AppData.trans('Select Language'),
            subtitle: AppData.selectedLanguage,
            onTap: _changeLanguage,
          ),

          // Profile Section
          _buildSettingsCard(
            icon: Icons.person_outline,
            title: AppData.trans('Edit Profile'),
            subtitle: AppData.currentUser.name,
            onTap: _editProfile,
          ),

          // Notifications Section
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(Icons.notifications_none, color: gold),
              title: Text(AppData.trans('Turn on notifications'),
                  style: const TextStyle(
                      fontFamily: 'serif', fontWeight: FontWeight.w600)),
              value: pushNotifications,
              activeColor: gold,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
          ),

          const SizedBox(height: 32),

          // Logout Section
          _buildSettingsCard(
            icon: Icons.logout,
            title: AppData.trans('Logout'),
            subtitle: 'Sign out of your account',
            onTap: _logout,
            isDestructive: false, // Set to false to maintain gold theme
          ),
        ],
      ),
    );
  }

  // Helper widget to keep UI consistent
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
        leading: Icon(icon, color: isDestructive ? Colors.red : gold),
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
