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
  String selectedTab = "Requests";
  final searchController = TextEditingController();
  String? selectedBloodFilter;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter by Blood Group", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          setState(() => selectedBloodFilter = null);
                          Navigator.pop(context);
                        },
                        child: const Text("Clear", style: TextStyle(color: AppColors.primaryRed)),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    children: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((group) {
                      final bool isSelected = selectedBloodFilter == group;
                      return ChoiceChip(
                        label: Text(group),
                        selected: isSelected,
                        selectedColor: AppColors.primaryRed,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        onSelected: (selected) {
                          setState(() => selectedBloodFilter = selected ? group : null);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppColors.primaryRed,
          elevation: 2,
          title: const Text(
            "BloodLink",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
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
              RichText(
                text: TextSpan(
                  text: "Hello, ",
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: authProvider.user?.name ?? 'User',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
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
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: selectedBloodFilter != null ? Colors.blue : AppColors.primaryRed),
                      onPressed: _showFilterSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTab("Requests"),
                  const SizedBox(width: 20),
                  _buildTab("Donors"),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: selectedTab == "Requests"
                    ? _buildRequestsView()
                    : _buildDonorsView(),
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
          label: const Text("Request Blood", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildRequestsView() {
    return StreamBuilder(
      stream: DatabaseService().getBloodRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No blood requests found"));

        final query = searchController.text.toLowerCase();
        final filtered = snapshot.data!.where((r) {
          final matchesSearch = r.bloodGroup.toLowerCase().contains(query) || r.location.toLowerCase().contains(query);
          final matchesFilter = selectedBloodFilter == null || r.bloodGroup == selectedBloodFilter;
          return matchesSearch && matchesFilter;
        }).toList();

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => BloodCardWidget(request: filtered[index], onTap: () {}),
        );
      },
    );
  }

  Widget _buildDonorsView() {
    return StreamBuilder<List<UserModel>>(
      stream: DatabaseService().getDonors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No donors available"));

        final query = searchController.text.toLowerCase();
        final filtered = snapshot.data!.where((user) {
          final matchesSearch = user.bloodGroup.toLowerCase().contains(query) || user.location.toLowerCase().contains(query);
          final matchesFilter = selectedBloodFilter == null || user.bloodGroup == selectedBloodFilter;
          return matchesSearch && matchesFilter;
        }).map((user) => DonorModel.fromUserModel(user)).toList();

        if (filtered.isEmpty) return const Center(child: Text("No donors match your criteria"));

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => DonorCardWidget(donor: filtered[index]),
        );
      },
    );
  }

  Widget _buildTab(String label) {
    final bool isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}