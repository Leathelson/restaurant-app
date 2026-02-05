import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/main.dart';
import '../../models/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish']
              .map(
                (lang) => RadioListTile<String>(
                  title: Text(lang),
                  value: lang,
                  groupValue: AppData.selectedLanguage,
                  activeColor: Colors.amber,
                  onChanged: (value) {
                    setState(() {
                      AppData.selectedLanguage = value!;
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
    final nameController = TextEditingController(
      text: AppData.currentUser.name,
    );
    final emailController = TextEditingController(
      text: AppData.currentUser.email,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppData.currentUser.name = nameController.text;
                AppData.currentUser.email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context); // just close the dialog },
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => AuthGate()),
                (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.language, color: Colors.amber),
              title: Text('Language'),
              subtitle: Text(AppData.selectedLanguage),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _changeLanguage,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.amber),
              title: Text('Edit Profile'),
              subtitle: Text('Update your personal information'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _editProfile,
            ),
          ),
          Card(
            child: SwitchListTile(
              secondary: Icon(Icons.notifications, color: Colors.amber),
              title: Text('Push Notifications'),
              subtitle: Text('Receive order updates and offers'),
              value: pushNotifications,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}
