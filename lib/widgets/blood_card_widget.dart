import 'package:flutter/material.dart';
import '../models/blood_request_model.dart';
import '../utils/app_colors.dart';

class BloodCardWidget extends StatelessWidget {
  final BloodRequestModel request;
  final VoidCallback? onTap; // ✅ Tap support

  const BloodCardWidget({
    super.key,
    required this.request,
    this.onTap, // ✅ constructor
  });

  @override
  Widget build(BuildContext context) {
    // Urgency color dynamically
    final urgencyColor = request.isUrgent ? AppColors.primaryRed : Colors.grey;

    return GestureDetector(
      onTap: onTap, // ✅ interactive
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Blood Group Circle
              CircleAvatar(
                backgroundColor: AppColors.primaryRed,
                radius: 28,
                child: Text(
                  request.bloodGroup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Request Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location: ${request.location}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Units: ${request.units} | Contact: ${request.contact}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.isUrgent ? "Urgent Requirement" : "Normal",
                      style: TextStyle(
                        color: urgencyColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing arrow
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
