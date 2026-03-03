import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // The AuthWrapper in main.dart will automatically
              // take you back to the Login screen now.
            },
          )
        ],
      ),
      body: const Center(child: Text("Welcome to the Restaurant!")),
    );
  }
}
