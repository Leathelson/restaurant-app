import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxury_restaurant_app/models/app_data.dart' hide User;
import 'package:luxury_restaurant_app/services/sound_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isLoading = false;

  static const Color gold = Color(0xFFB37C1E);

  Future<void> _register() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();

    // 1. Validation
    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('please_fill_all'))),
      );
      return;
    }

    if (password != _confirmController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('passwords_dont_match'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Create User in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 3. Update Profile Name Immediately
      await user.updateDisplayName(name);

      // 4. Save to Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'Uid': user.uid,
          'Name': name,
          'Phone': phone,
          'Email': email,
          'DateofEntry': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        debugPrint("Firestore Error: $firestoreError");
        // We don't delete the user here anymore to avoid the "bounce" back,
        // just let them proceed to dashboard.
      }

      if (!mounted) return;

      // FIX: Use pushNamedAndRemoveUntil to force the app into the Dashboard
      // and prevent it from "popping" back to the Login screen.
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    } on FirebaseAuthException catch (e) {
      debugPrint("FIREBASE AUTH ERROR: ${e.code}");

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              "This email is already registered. Please login instead.";
          break;
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        default:
          errorMessage = e.message ?? "Registration failed. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
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
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      AppData.trans('sign_up_title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton('assets/icons/facebook.png'),
                        _socialButton('assets/icons/instagram.png'),
                        _socialButton('assets/icons/x_icon.png'),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _inputField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hint: AppData.trans('name_hint'),
                      icon: Icons.person_outline,
                    ),
                    _inputField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      hint: AppData.trans('phone_hint'),
                      icon: Icons.phone_android_outlined,
                      keyboard: TextInputType.phone,
                    ),
                    _inputField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hint: AppData.trans('email_hint'),
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                    ),
                    _inputField(
                      controller: _passwordController,
                      focusNode: _passFocus,
                      hint: AppData.trans('password_hint'),
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    _inputField(
                      controller: _confirmController,
                      focusNode: _confirmFocus,
                      hint: AppData.trans('confirm_password_hint'),
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                SoundService.playClick();
                                _register();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                AppData.trans('register_button').toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white, fontFamily: 'serif'),
        cursorColor: gold,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: Colors.white70, size: 22),
          filled: true,
          fillColor: Colors.black.withOpacity(0.7),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: gold.withOpacity(0.7), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: gold, width: 1.8),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return IconButton(
      onPressed: () => SoundService.playClick(),
      icon: Image.asset(assetPath,
          width: 28,
          height: 28,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.circle, color: Colors.white)),
    );
  }
}
