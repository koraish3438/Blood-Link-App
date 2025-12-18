import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String uid = authProvider.user?.uid ?? "";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 0,
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white, // ✅ readable on red
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel?>(
        future: DatabaseService().getUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryRed));
          }
          final user = snapshot.data;
          if (user == null) return const Center(child: Text("User not found"));

          // ✅ Fetch dynamic stats from database
          return FutureBuilder<Map<String, int>>(
            future: DatabaseService().getUserStats(uid),
            builder: (context, statsSnapshot) {
              int donated = 0, requests = 0, followers = 0;
              if (statsSnapshot.hasData) {
                donated = statsSnapshot.data!['donated'] ?? 0;
                requests = statsSnapshot.data!['requests'] ?? 0;
                followers = statsSnapshot.data!['followers'] ?? 0;
              }

              return SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        child:
                        Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // ✅ readable on red background
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70, // ✅ readable
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Donation Stats Dynamic
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn("Donated", donated),
                            _buildStatColumn("Requests", requests),
                            _buildStatColumn("Followers", followers),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Info Cards
                    _buildProfileCard(
                        Icons.bloodtype, "Blood Group", user.bloodGroup),
                    _buildProfileCard(
                        Icons.location_on, "Location", user.location),
                    _buildProfileCard(
                        Icons.verified_user, "Status", "Active Donor"),

                    const SizedBox(height: 40),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          await authProvider.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Profile Info Card
  Widget _buildProfileCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryRed, size: 28),
        title: Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  // Donation stats column
  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
