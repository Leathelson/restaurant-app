import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/screens/auth/forgot_password.dart';
import 'package:luxury_restaurant_app/models/app_data.dart'; // REQUIRED for translations
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'dart:async';
import '../../services/sound_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _remember = false;

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();

      if (_remember) {
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppData.trans('login_failed')}: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFB37C1E);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/glassesandshi.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 8),
                  Text(
                    AppData.trans('Login'), // TRANSLATED: 'Log In'
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/icons/facebook.png'),
                      _socialButton('assets/icons/instagram.png'),
                      _socialButton('assets/icons/x_icon.png'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/emblem.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_dining,
                            color: Colors.white70,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _inputField(
                    controller: _emailController,
                    hint: AppData.trans('email'), // TRANSLATED: "Email"
                    icon: Icons.email_outlined,
                    fillColor: Colors.black.withOpacity(0.55),
                    keyboard: TextInputType.emailAddress,
                  ),
                  _inputField(
                    controller: _passwordController,
                    hint: AppData.trans('password'), // TRANSLATED: "Password"
                    icon: Icons.lock_outline,
                    fillColor: Colors.black.withOpacity(0.55),
                    obscure: true,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        SoundService.playClick();
                      _login;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 8,
                      ),
                      child: Text(
                        AppData.trans('Login'), // TRANSLATED: 'Log In'
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            SoundService.playClick();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const ForgotPassword()),
                            );
                          },
                          child: Text(
                            AppData.trans('Forgot Password?'), // TRANSLATED
                            style: const TextStyle(
                                color: gold, fontFamily: 'serif'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            SoundService.playClick();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            AppData.trans('Sign up'), // TRANSLATED
                            style: const TextStyle(
                                color: gold, fontFamily: 'serif'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: w * 0.12),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color fillColor,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: const Color(0xFF906224).withOpacity(0.60), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: const Color(0xFF906224).withOpacity(0.40), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFB37C1E), width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: IconButton(
        onPressed: () {
          SoundService.playClick();
        },
        icon: Image.asset(assetPath, width: 28, height: 28),
        splashRadius: 20,
      ),
    );
  }
}
