import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account Recovery'),
          backgroundColor: Colors.black.withOpacity(0.28),
        ),
        body: Text('Can you see me ??'));
  }
}
