import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Login Screen Coming Soon",
          style: TextStyle(color: AppColors.primaryRed, fontSize: 20),
        ),
      ),
    );
  }
}