import 'package:flutter/material.dart';
import '../models/donor_model.dart';
import '../utils/app_colors.dart';

class DonorCardWidget extends StatelessWidget {
  final DonorModel donor;
  final VoidCallback? onTap;

  const DonorCardWidget({
    super.key,
    required this.donor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final availabilityColor = donor.isAvailable ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: onTap,
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
                  donor.bloodGroup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Donor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Location: ${donor.location}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      donor.isAvailable ? "Available to donate" : "Currently unavailable",
                      style: TextStyle(
                        color: availabilityColor,
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
