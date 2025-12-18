import 'package:flutter/material.dart';
import '../models/blood_request_model.dart';
import '../utils/app_colors.dart';

class BloodCardWidget extends StatelessWidget {
  final BloodRequestModel request;
  const BloodCardWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryRed,
          radius: 25,
          child: Text(request.bloodGroup,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text("Location: ${request.location}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Units: ${request.units} | Contact: ${request.contact}"),
            const Text("Urgent Requirement", style: TextStyle(color: AppColors.primaryRed, fontSize: 12)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}