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

  String getLastDonationText(int timestamp) {
    if (timestamp == 0) return "No donation history";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return "Donated today";
    if (days == 1) return "Donated 1 day ago";
    return "Last donated $days days ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Profile Photo ---
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.primaryRed,
                  child: const Icon(Icons.person, size: 60, color: Colors.white),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18, color: AppColors.primaryRed),
                    onPressed: () {
                      // TODO: Implement profile photo upload
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Editable Fields ---
            CustomTextField(hintText: "Full Name", icon: Icons.person, controller: _nameController),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Phone Number", icon: Icons.phone, controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Location", icon: Icons.location_on, controller: _locationController),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Address", icon: Icons.location_city, controller: _addressController),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Age", icon: Icons.cake, controller: _ageController, keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Weight (kg)", icon: Icons.monitor_weight, controller: _weightController, keyboardType: TextInputType.number),
            const SizedBox(height: 20),

            // --- Availability Switch ---
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

            // --- Save Changes Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    await DatabaseService().updateUserData(widget.user.uid, {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'location': _locationController.text.trim(),
      'address': _addressController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? widget.user.age,
      'weight': int.tryParse(_weightController.text.trim()) ?? widget.user.weight,
      'isAvailable': _availability,
    });

    setState(() => _isLoading = false);
    Navigator.pop(context); // back to profile screen
  }
}
