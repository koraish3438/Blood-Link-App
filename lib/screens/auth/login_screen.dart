import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.bloodtype, size: 80, color: AppColors.primaryRed),
              const SizedBox(height: 20),
              const Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              const CustomTextField(hintText: "Email", icon: Icons.email),
              const SizedBox(height: 15),
              const CustomTextField(hintText: "Password", icon: Icons.lock, isPassword: true),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text("Don't have an account? Register", style: TextStyle(color: AppColors.primaryRed)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}