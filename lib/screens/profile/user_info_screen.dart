import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize with current global data
    nameController = TextEditingController(text: AppData.currentUser.name);
    emailController = TextEditingController(text: AppData.currentUser.email);

    // Note: If your User model doesn't have password/phone,
    // these will default to empty strings or example text.
    passwordController =
        TextEditingController(text: AppData.currentUser.password ?? "");
    phoneController = TextEditingController(
        text: AppData.currentUser.phone ?? "+230 5123 4567");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      // SAVE ALL FIELDS TO GLOBAL DATA
      AppData.currentUser.name = nameController.text;
      AppData.currentUser.email = emailController.text;
      AppData.currentUser.password = passwordController.text;
      AppData.currentUser.phone = phoneController.text;
    });

    // Custom Maroon SnackBar for a better UI match
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppData.trans("Profile Updated"),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color maroonTitle = Color(0xFF63210B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppData.trans('Edit Profile'),
          style: TextStyle(
            color: maroonTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Picture Section
              const Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Fields with full translation support
              _buildTextField(
                  AppData.trans("Name"), nameController, Colors.brown.shade600),
              _buildTextField(AppData.trans("Email"), emailController,
                  const Color(0xFF2F2740)),
              _buildTextField(AppData.trans("Password"), passwordController,
                  Colors.brown.shade600,
                  obscure: true, hint: "********"),
              _buildTextField(AppData.trans("Phone Number"), phoneController,
                  Colors.brown.shade600,
                  hint: "+ 230 5123 4567"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color bgColor, {
    bool obscure = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.red.shade900)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
