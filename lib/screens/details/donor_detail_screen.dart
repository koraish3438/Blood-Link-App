import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/donor_model.dart';
import '../../utils/app_colors.dart';

class DonorDetailScreen extends StatelessWidget {
  final DonorModel donor;
  const DonorDetailScreen({super.key, required this.donor});

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Profile"),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primaryRed.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 80, color: AppColors.primaryRed),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: donor.isAvailable ? Colors.green : Colors.grey,
                    child: const Icon(Icons.check, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(donor.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              donor.isAvailable ? "Available to Donate" : "Currently Unavailable",
              style: TextStyle(color: donor.isAvailable ? Colors.green : Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _infoTile(Icons.bloodtype, "Blood Group", donor.bloodGroup),
                  const Divider(indent: 70),
                  _infoTile(Icons.location_on, "Location", donor.location),
                  const Divider(indent: 70),
                  _infoTile(Icons.phone, "Phone", donor.phone),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (donor.isAvailable)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _makeCall(donor.phone),
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text("Call Donor", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primaryRed.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primaryRed),
      ),
      title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
    );
  }
}