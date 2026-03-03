import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/screens/auth/forgot_password.dart';
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import '../../services/sound_service.dart';
// REMOVED: import '../../pages/home.dart';
import 'package:luxury_restaurant_app/main.dart'; // To access DashboardScreen and languageNotifier

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool _remember = false;
  bool _isLoading = false;

  static const Color gold = Color(0xFFB37C1E);

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('enter_credentials_error'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      if (_remember) {
        await prefs.setString('Email', _emailController.text.trim());
        await prefs.setString('Password', _passwordController.text.trim());
      }

      if (!mounted) return;

      // FIX: Redirect to DashboardScreen instead of the blank HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFriendlyErrorMessage(e.code);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${AppData.trans('error')}: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getFriendlyErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return AppData.trans('user_not_found');
      case 'wrong-password':
        return AppData.trans('wrong_password');
      case 'invalid-credential':
        return AppData.trans('invalid_credential_msg');
      default:
        return AppData.trans('login_failed');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/glassesandshi.jpg',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.9)
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
                    AppData.trans('login_title'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif'),
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
                            color: Colors.white.withOpacity(0.16), width: 1.4),
                      ),
                      child: Center(
                        child: Image.asset('assets/images/emblem.png',
                            width: 120, height: 120, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _inputField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    hint: AppData.trans('Email_hint'),
                    icon: Icons.email_outlined,
                    fillColor: Colors.black.withOpacity(0.75),
                    keyboard: TextInputType.emailAddress,
                  ),
                  _inputField(
                    controller: _passwordController,
                    focusNode: _passFocus,
                    hint: AppData.trans('Password_hint'),
                    icon: Icons.lock_outline,
                    fillColor: Colors.black.withOpacity(0.75),
                    obscure: true,
                  ),
                  Row(
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.white,
                          checkboxTheme: CheckboxThemeData(
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _remember,
                            activeColor: gold,
                            checkColor: Colors.white,
                            onChanged: (val) =>
                                setState(() => _remember = val ?? false),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppData.trans('remember_me'),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'serif'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        SoundService.playClick();
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(AppData.trans('login_button'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'serif')),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
      {required TextEditingController controller,
      required FocusNode focusNode,
      required String hint,
      required IconData icon,
      required Color fillColor,
      bool obscure = false,
      TextInputType keyboard = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        cursorColor: gold,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          prefixIcon: Icon(icon, color: Color(0xFFB37C1E)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: gold, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: gold, width: 1.0)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child:
          IconButton(onPressed: () {}, icon: Image.asset(assetPath, width: 28)),
    );
  }
}
