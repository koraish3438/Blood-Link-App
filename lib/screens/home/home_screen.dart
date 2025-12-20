import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/blood_card_widget.dart';
import '../../widgets/donor_card_widget.dart';
import '../../utils/app_colors.dart';
import 'request_blood_screen.dart';
import '../profile/profile_screen.dart';
import '../../models/donor_model.dart';
import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTab = "Donors"; // শুরুতে Donors tab
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 2,
        // টেক্সট কালার সাদা করা হয়েছে যাতে পরিষ্কার দেখা যায়
        title: const Text(
          "BloodLink",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 28, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting - আপনার রেজিস্টার্ড নাম এখানে দেখাবে
            RichText(
              text: TextSpan(
                text: "Hello, ",
                style: const TextStyle(fontSize: 20, color: Colors.black54),
                children: [
                  TextSpan(
                    text: authProvider.user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Connecting donors and helping those in need",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Search Bar with Filter Option (পছন্দের ডিজাইন অনুযায়ী)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search by blood group or location",
                        border: InputBorder.none,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  // ফিল্টার অপশনটি এখানে আবার যোগ করা হয়েছে
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.primaryRed),
                    onPressed: () {
                      // এখানে ফিল্টার লজিক বা ডায়ালগ দিতে পারেন
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTab("Donors"),
                const SizedBox(width: 20),
                _buildTab("Requests"),
              ],
            ),
            const SizedBox(height: 12),

            // Scrollable List
            Expanded(
              child: selectedTab == "Requests"
                  ? _buildRequestsView()
                  : _buildDonorsView(), // নিজের আইডি সহ দেখার লজিক আপডেট করা হয়েছে
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RequestBloodScreen()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Request Blood",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ব্লাড রিকোয়েস্ট লিস্ট ভিউ
  Widget _buildRequestsView() {
    return StreamBuilder(
      stream: DatabaseService().getBloodRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No blood requests found", style: TextStyle(color: Colors.grey)),
          );
        }

        final query = searchController.text.toLowerCase();
        final filtered = snapshot.data!.where((r) =>
        r.bloodGroup.toLowerCase().contains(query) ||
            r.location.toLowerCase().contains(query)).toList();

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return BloodCardWidget(
              request: filtered[index],
              onTap: () {},
            );
          },
        );
      },
    );
  }

  // ডোনার লিস্ট ভিউ
  Widget _buildDonorsView() {
    return StreamBuilder<List<UserModel>>(
      stream: DatabaseService().getDonors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No donors available", style: TextStyle(color: Colors.grey)),
          );
        }

        final query = searchController.text.toLowerCase();

        // লজিক আপডেট: এখানে currentUid ফিল্টার করা হয়নি, তাই আপনি নিজেকেও দেখতে পাবেন
        final filtered = snapshot.data!.where((user) =>
        (user.bloodGroup.toLowerCase().contains(query) ||
            user.location.toLowerCase().contains(query))
        ).map((user) => DonorModel.fromUserModel(user)).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text("No donors match your search"));
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return DonorCardWidget(donor: filtered[index]);
          },
        );
      },
    );
  }

  // ট্যাব ডিজাইন (অরিজিনাল ডিজাইন অনুযায়ী)
  Widget _buildTab(String label) {
    final bool isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}