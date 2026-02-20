import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
// Only ONE import for AppData, hiding the User class to avoid conflicts
import 'package:luxury_restaurant_app/models/app_data.dart' hide User;

// 1. Define the global notifier with a fallback to 'en' to avoid null errors
ValueNotifier<String> languageNotifier =
    ValueNotifier(AppData.selectedLanguage);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure AppData has a default language before the UI builds
  if (AppData.selectedLanguage.isEmpty) {
    AppData.selectedLanguage = 'en';
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Wrap everything in the Notifier to rebuild on language change
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLanguage, child) {
        return MaterialApp(
          // Uses the trans() method for the app title
          title: AppData.trans('app_title'),
          theme: ThemeData(
            primarySwatch: Colors.amber,
            fontFamily: 'serif',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.amber,
            ),
          ),
          home: const AuthGate(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle loading state properly
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, go to Dashboard, otherwise go to Login
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
