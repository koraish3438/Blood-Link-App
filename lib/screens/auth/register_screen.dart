import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ব্লাড গ্রুপের লিস্ট
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
              ),
              const SizedBox(height: 10),
              const Text("Join our community and save lives", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              // Input Fields
              const CustomTextField(hintText: "Full Name", icon: Icons.person),
              const SizedBox(height: 15),
              const CustomTextField(hintText: "Email", icon: Icons.email),
              const SizedBox(height: 15),
              const CustomTextField(hintText: "Phone Number", icon: Icons.phone),
              const SizedBox(height: 15),

              // Blood Group Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Select Blood Group"),
                    isExpanded: true,
                    value: selectedGroup,
                    items: bloodGroups.map((String group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const CustomTextField(hintText: "Password", icon: Icons.lock, isPassword: true),
              const SizedBox(height: 30),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // পরে এখানে রেজিস্ট্রেশন লজিক লিখবো
                  },
                  child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}