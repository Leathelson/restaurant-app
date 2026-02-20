import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:luxury_restaurant_app/models/app_data.dart'
    hide User; //  This allows FirebaseAuth to own the 'User' name
// This tells Flutter: "Import everything from AppData EXCEPT the 'User' class"
import 'package:luxury_restaurant_app/models/app_data.dart' hide User;
=======
import 'package:luxury_restaurant_app/services/sound_service.dart';
>>>>>>> 0e9ee9c9cf8997385ab5b2c409b5a5e6e2071c05

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

  Future<void> _register() async {
    // Translated Validation Messages
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('Please fill all fields'))),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('Passwords do not match'))),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) return;

      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'Uid': user.uid,
          'Name': _nameController.text.trim(),
          'Phone': _phoneController.text.trim(),
          'Email': _emailController.text.trim(),
          'DateofEntry': DateTime.now(),
        });
      } catch (firestoreError) {
        await user.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppData.trans('save_error'))),
        );
        return;
      }

      await userCredential.user!.updateDisplayName(_nameController.text.trim());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed, Servers Offline')),
      );
    }

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Color get gold => const Color(0xFFB37C1E);
  Color get goldCard => const Color(0xFF906224);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final topPadding = MediaQuery.of(context).padding.top;

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
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7)
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth,
                  minHeight: screenHeight - topPadding,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          AppData.trans('register'), // TRANSLATED: "Sign Up"
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
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
                          hint: AppData.trans('Name'), // TRANSLATED
                          icon: Icons.person_outline,
                          fillColor: Colors.black.withOpacity(0.5),
                        ),
                        _inputField(
                          controller: _phoneController,
                          hint: AppData.trans('Phone'), // TRANSLATED
                          icon: Icons.phone_android_outlined,
                          fillColor: Colors.black.withOpacity(0.5),
                          keyboard: TextInputType.phone,
                        ),
                        _inputField(
                          controller: _emailController,
                          hint: AppData.trans('Email'), // TRANSLATED
                          icon: Icons.email_outlined,
                          fillColor: Colors.black.withOpacity(0.5),
                          keyboard: TextInputType.emailAddress,
                        ),
                        _inputField(
                          controller: _passwordController,
                          hint: AppData.trans('Password'), // TRANSLATED
                          icon: Icons.lock_outline,
                          fillColor: Colors.black.withOpacity(0.5),
                          obscure: true,
                        ),
                        _inputField(
                          controller: _confirmController,
                          hint: AppData.trans('Confirm Password'), // TRANSLATED
                          icon: Icons.lock_outline,
                          fillColor: Colors.black.withOpacity(0.5),
                          obscure: true,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              SoundService.playClick();
                              _register();
                            } ,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                            ),
                            child: Text(
                              AppData.trans('register'), // TRANSLATED
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
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
          prefixIcon: Icon(icon, color: gold),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: const Color(0xFF906224).withOpacity(0.60), width: 5),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return IconButton(
      onPressed: () {
        SoundService.playClick();
      },
      icon: Image.asset(
        assetPath,
        width: 30,
        height: 30,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.circle, color: Colors.white),
      ),
    );
  }
}
