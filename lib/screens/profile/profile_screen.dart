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
    return days == 0 ? "Donated today" : "Last donated $days days ago";
  }

  void _showDeleteDialog(BuildContext context, String uid, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Delete Account?", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text("This action is permanent and all your data will be removed. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Keep Account", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, elevation: 0),
            onPressed: () async {
              await DatabaseService().deleteUserAccount(uid);
              await authProvider.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              }
            },
            child: const Text("Delete Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final uid = authProvider.user?.uid ?? "";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<UserModel?>(
        future: DatabaseService().getUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final user = snapshot.data;
          if (user == null) return const Center(child: Text("Error loading profile"));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.primaryRed, Color(0xFFB71C1C)])),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.primaryRed,
                    backgroundImage: (user.profilePic != null && user.profilePic!.isNotEmpty) ? NetworkImage(user.profilePic!) : null,
                    child: (user.profilePic == null || user.profilePic!.isEmpty) ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                  ),
                ),
                const SizedBox(height: 15),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: user))).then((_) => setState(() {}));
                }),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: SwitchListTile(
                    title: const Text("Available to Donate", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Toggle this to show/hide you in Donor list", style: TextStyle(fontSize: 12)),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                    },
                    child: const Text("Logout Account", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text("Danger Zone", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Once you delete your account, there is no going back. All your records will be cleared.", style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _showDeleteDialog(context, uid, authProvider),
                          child: const Text("Delete My Account", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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