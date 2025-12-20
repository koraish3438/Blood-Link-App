import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  bool _isLoading = false;
  bool _availability = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _locationController = TextEditingController(text: widget.user.location);
    _addressController = TextEditingController(text: widget.user.address);
    _ageController = TextEditingController(text: widget.user.age.toString());
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _availability = widget.user.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primaryRed, // ব্যাকগ্রাউন্ড লাল
        foregroundColor: Colors.white,         // টেক্সট ও আইকন সাদা
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [AppColors.primaryRed, Color(0xFFB71C1C)]),
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.primaryRed,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 18, color: AppColors.primaryRed),
                ),
              ],
            ),
            const SizedBox(height: 25),
            CustomTextField(hintText: "Full Name", icon: Icons.person, controller: _nameController),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Phone Number", icon: Icons.phone, controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Location", icon: Icons.location_on, controller: _locationController),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Address", icon: Icons.location_city, controller: _addressController),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Age",
                    icon: Icons.cake,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextField(
                    hintText: "Weight (kg)",
                    icon: Icons.monitor_weight,
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                activeColor: AppColors.primaryRed,
                title: const Text("Available to Donate", style: TextStyle(fontWeight: FontWeight.bold)),
                value: _availability,
                onChanged: (value) {
                  setState(() => _availability = value);
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      await DatabaseService().updateUserData(widget.user.uid, {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'address': _addressController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? widget.user.age,
        'weight': int.tryParse(_weightController.text.trim()) ?? widget.user.weight,
        'isAvailable': _availability,
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}