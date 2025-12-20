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
        elevation: 0,
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
                const SizedBox(height: 15),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 25),
                FutureBuilder<Map<String, int>>(
                  future: DatabaseService().getUserStats(uid),
                  builder: (context, statsSnap) {
                    final stats = statsSnap.data ?? {'donated': 0, 'requests': 0, 'helped': 0};
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat("Donated", stats['donated']!),
                            _buildStat("Requests", stats['requests']!),
                            _buildStat("Helped", stats['helped']!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildActionTile(Icons.edit, "Edit Profile Information", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                  ).then((_) => setState(() {}));
                }),
                const SizedBox(height: 10),
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
                _infoCard(Icons.bloodtype, "Blood Group", user.bloodGroup),
                _infoCard(Icons.phone, "Phone Number", user.phone),
                _infoCard(Icons.location_on, "Location", user.location),
                _infoCard(Icons.location_city, "Address", user.address),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCard(Icons.cake, "Age", "${user.age}")),
                    const SizedBox(width: 10),
                    Expanded(child: _infoCard(Icons.monitor_weight, "Weight", "${user.weight} kg")),
                  ],
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.primaryRed.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Logout Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
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
        Text(value.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    ),
  );

  Widget _infoCard(IconData icon, String title, String value) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
    ),
  );
}