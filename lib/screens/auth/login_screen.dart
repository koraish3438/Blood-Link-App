import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              // Logo & Title Section
              const Icon(Icons.bloodtype, size: 80, color: AppColors.primaryRed),
              const SizedBox(height: 10),
              const Text(
                AppConstants.appName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
              ),
              const Text("Connecting donors, saving lives", style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Welcome Back", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              // Input Fields
              const CustomTextField(hintText: "Email or Phone Number", icon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(hintText: "Password", icon: Icons.lock_outline, isPassword: true),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: () {},
                  child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 40),

              // Bottom Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text("Register", style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}