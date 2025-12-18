import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/blood_card_widget.dart';
import '../../utils/app_colors.dart';
import 'request_blood_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("BloodLink", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, ${authProvider.user?.email?.split('@')[0] ?? 'User'}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const Text("Find blood requests nearby", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: DatabaseService().getBloodRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No requests found"));

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => BloodCardWidget(request: snapshot.data![index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestBloodScreen())),
        label: const Text("Request Blood", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}