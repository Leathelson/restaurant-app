import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/dashboard_screen.dart';
import 'register_screen.dart';
import 'dart:convert';
import 'dart:async';
import '../../services/socket_service.dart';

late StreamSubscription _socketSub;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SocketService _socket = SocketService();
  bool _isLoading = false;
  bool _remember = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter email and password")),
        );
        return;
      }

      setState(() => _isLoading = true);

      _socket.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
  }

  @override
void initState() {
  super.initState();

  _socketSub = SocketService.instance.stream.listen(
    (message) async {
      final data = jsonDecode(message);

      if (data['type'] != 'login') return;
      if (!mounted) return;

      setState(() => _isLoading = false);

      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);

        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }

        if (_remember) {
          await prefs.setString('email', _emailController.text);
        } else {
          await prefs.remove('email');
        }

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login failed'),
          ),
        );
      }
    },
  );
}
  @override
  void dispose() {
    _socketSub.cancel(); 
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFB37C1E);
    const goldCard = Color(0xFF906224);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, //  prevents bg from moving with keyboard
      body: Stack(
        children: [
          // background image stays fixed
          Positioned.fill(
            child: Image.asset(
              'assets/images/glassesandshi.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.28),
                    Colors.black.withOpacity(0.58),
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
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // social icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/icons/facebook.png'),
                      _socialButton('assets/icons/instagram.png'),
                      _socialButton('assets/icons/x_icon.png'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // emblem circle
                  Center(
                    child: Container(
                      width: 150, // bigger circle
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
                          width: 120, // bigger emblem
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_dining,
                            color: Colors.white70,
                            size: 64, // bigger fallback icon too
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Email field
                  _inputField(
                    controller: _emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    fillColor: goldCard.withOpacity(0.95),
                    keyboard: TextInputType.emailAddress,
                  ),

                  // Password field
                  _inputField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    fillColor: Colors.black.withOpacity(0.45),
                    obscure: true,
                  ),

                  const SizedBox(height: 8),

                  // remember + forgot
                  Row(
                    children: [
                      Checkbox(
                        value: _remember,
                        onChanged: (v) =>
                            setState(() => _remember = v ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: gold,
                        checkColor: Colors.black,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: forgot password flow
                        },
                        child: const Text(
                          'forgot password',
                          style: TextStyle(
                            color: Colors.redAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Log In button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // register link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: gold),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: IconButton(
        onPressed: () {},
        icon: Image.asset(assetPath, width: 28, height: 28),
        splashRadius: 20,
      ),
    );
  }
}
