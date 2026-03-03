import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _isSent = false;
  bool _isLoading = false;

  // Matched Gold from your Login/Register theme
  static const Color gold = Color(0xFFB37C1E);

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('please_enter_email'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _isSent = true;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = AppData.trans('error_occurred');

      if (e.code == 'user-not-found') {
        errorMessage = AppData.trans('no_account_found');
      } else if (e.code == 'invalid-email') {
        errorMessage = AppData.trans('invalid_email_format');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppData.trans('connection_failed'))),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/glassesandshi.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () {
                        SoundService.playClick();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child:
                        _isSent ? _buildSuccessState() : _buildRequestState(),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestState() {
    return Column(
      key: const ValueKey(1),
      children: [
        Text(
          AppData.trans('forgot_password_title'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 15),
        Text(
          AppData.trans('forgot_password_subtitle'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 40),
        _inputField(
          controller: _emailController,
          hint: AppData.trans('email_hint'),
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 8,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Text(
                    AppData.trans('send_link_button').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      key: const ValueKey(2),
      children: [
        const Icon(Icons.mark_email_read_outlined, color: gold, size: 60),
        const SizedBox(height: 20),
        Text(
          AppData.trans('check_email_title'),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif'),
        ),
        const SizedBox(height: 15),
        Text(
          AppData.trans('recovery_sent_msg'),
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white70, fontSize: 16, fontFamily: 'serif'),
        ),
        const SizedBox(height: 40),
        TextButton(
          onPressed: () {
            SoundService.playClick();
            Navigator.pop(context);
          },
          child: Text(
            AppData.trans('back_to_login'),
            style: const TextStyle(
                color: gold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'serif'),
          ),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontFamily: 'serif'),
      keyboardType: TextInputType.emailAddress,
      cursorColor: gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.7), // Matched Opacity
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        // GOLD BORDERS
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: gold.withOpacity(0.7), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: gold, width: 1.8),
        ),
      ),
    );
  }
}
