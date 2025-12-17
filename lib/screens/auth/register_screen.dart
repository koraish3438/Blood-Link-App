import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
              const Text("Join BloodLink and save lives", style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 40),
              const CustomTextField(hintText: "Full Name", icon: Icons.person_outline),
              const SizedBox(height: 16),
              const CustomTextField(hintText: "Email or Phone", icon: Icons.email_outlined),
              const SizedBox(height: 16),

              // Blood Group & Location (Row or Column)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text("Blood"),
                          value: selectedGroup,
                          items: bloodGroups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (v) => setState(() => selectedGroup = v),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    flex: 2,
                    child: CustomTextField(hintText: "City / Area", icon: Icons.location_on_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const CustomTextField(hintText: "Password", icon: Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),
              const CustomTextField(hintText: "Confirm Password", icon: Icons.lock_reset, isPassword: true),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Login", style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}