import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/blood_request_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_textfield.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroup;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Blood"),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Need Blood?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Fill the form to post a request", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            // Blood Group Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Blood Group"),
                  value: selectedGroup,
                  items: bloodGroups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState(() => selectedGroup = v),
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(hintText: "Location (Hospital/City)", icon: Icons.local_hospital, controller: _locationController),
            const SizedBox(height: 16),
            CustomTextField(hintText: "Units Required (e.g. 2)", icon: Icons.water_drop, controller: _unitsController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            CustomTextField(hintText: "Contact Number", icon: Icons.phone, controller: _contactController, keyboardType: TextInputType.phone),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : () async {
                  if (selectedGroup == null || _locationController.text.isEmpty || _contactController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
                    return;
                  }

                  setState(() => _isLoading = true);

                  final request = BloodRequestModel(
                    id: '',
                    bloodGroup: selectedGroup!,
                    location: _locationController.text.trim(),
                    units: _unitsController.text.trim(),
                    contact: _contactController.text.trim(),
                    userId: authProvider.user!.uid,
                    timestamp: 0,
                  );

                  await DatabaseService().addBloodRequest(request);

                  setState(() => _isLoading = false);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request Posted Successfully!")));
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Post Request", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}