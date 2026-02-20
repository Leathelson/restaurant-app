import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _isSent = false;
  bool _isLoading = false;

  // Colors refined for a sleeker look
  final Color gold = const Color(0xFFB37C1E);

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _isSent = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/glassesandshi.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Back Button - Updated to match standard font styles
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
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
        const Text(
          'Password Recovery',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700, // Matches your Login title weight
          ),
        ),
        const SizedBox(height: 15),

        // Simplified text, no container
        const Text(
          "Enter your email to reset your password",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 40),

        // Updated Input Field: Black border, thinner width
        _inputField(
          controller: _emailController,
          hint: "Email",
          icon: Icons.email_outlined,
        ),

        const SizedBox(height: 25),

        // Gold Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text(
                    'Send Link',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
        Icon(Icons.mark_email_read_outlined, color: gold, size: 60),
        const SizedBox(height: 20),
        const Text(
          "Check Your Email",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 40),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Back to Login",
              style: TextStyle(color: gold, fontWeight: FontWeight.w600)),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.6),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        // Border is now black and thinner (width: 1.5)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: gold.withOpacity(0.5), width: 1.5),
        ),
      ),
    );
  }
}
