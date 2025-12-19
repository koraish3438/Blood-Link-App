import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String getLastDonationText(int timestamp) {
    if (timestamp == 0) return "No donation history yet";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return "Donated today";
    if (days == 1) return "Donated 1 day ago";
    return "Last donated $days days ago";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final uid = authProvider.user?.uid ?? "";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final user = await DatabaseService().getUserData(uid);
              if (user == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
              ).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: DatabaseService().getUserData(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Image
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // Stats (Dynamic)
                FutureBuilder<Map<String, int>>(
                  future: DatabaseService().getUserStats(uid),
                  builder: (context, statsSnap) {
                    if (!statsSnap.hasData) return const SizedBox();
                    final stats = statsSnap.data!;
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat("Donated", stats['donated'] ?? 0),
                            _buildStat("Requests", stats['requests'] ?? 0),
                            _buildStat("Helped", stats['helped'] ?? 0),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Availability
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: SwitchListTile(
                    title: const Text("Available to Donate", style: TextStyle(fontWeight: FontWeight.bold)),
                    activeColor: AppColors.primaryRed,
                    value: user.isAvailable,
                    onChanged: (value) async {
                      await DatabaseService().updateUserAvailability(uid, value);
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(height: 10),
                _infoCard(Icons.history, "Last Donation", getLastDonationText(user.lastDonationDate)),
                const SizedBox(height: 10),

                _infoCard(Icons.bloodtype, "Blood Group", user.bloodGroup),
                _infoCard(Icons.phone, "Phone Number", user.phone),
                _infoCard(Icons.location_on, "Location", user.location),
                _infoCard(Icons.location_city, "Address", user.address),
                _infoCard(Icons.cake, "Age", "${user.age}"),
                _infoCard(Icons.monitor_weight, "Weight", "${user.weight} kg"),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}
