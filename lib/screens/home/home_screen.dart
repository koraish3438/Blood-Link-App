import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/blood_card_widget.dart';
import '../../widgets/donor_card_widget.dart';
import '../../utils/app_colors.dart';
import 'request_blood_screen.dart';
import '../profile/profile_screen.dart';
import '../details/request_detail_screen.dart';
import '../details/donor_detail_screen.dart';
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
  final locationFilterController = TextEditingController();
  String? selectedBloodFilter;

  String getDonorEligibility(int timestamp) {
    if (timestamp == 0) return "Available to donate";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference >= 90) return "Available to donate";
    return "Donated $difference days ago";
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedBloodFilter = null;
                            locationFilterController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Clear All", style: TextStyle(color: AppColors.primaryRed)),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("Blood Group", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((group) {
                      final bool isSelected = selectedBloodFilter == group;
                      return ChoiceChip(
                        label: Text(group),
                        selected: isSelected,
                        selectedColor: AppColors.primaryRed,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        onSelected: (selected) {
                          setModalState(() => selectedBloodFilter = selected ? group : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Location (Hospital/City)", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: locationFilterController,
                    decoration: InputDecoration(
                      hintText: "Enter hospital or city name",
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.primaryRed),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
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
                          hintText: "Search here...",
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: (selectedBloodFilter != null || locationFilterController.text.isNotEmpty)
                            ? Colors.blue
                            : AppColors.primaryRed,
                      ),
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
        final locFilter = locationFilterController.text.toLowerCase();

        final filtered = snapshot.data!.where((r) {
          final matchesSearch = r.bloodGroup.toLowerCase().contains(query) || r.location.toLowerCase().contains(query);
          final matchesBlood = selectedBloodFilter == null || r.bloodGroup == selectedBloodFilter;
          final matchesLoc = locFilter.isEmpty || r.location.toLowerCase().contains(locFilter);
          return matchesSearch && matchesBlood && matchesLoc;
        }).toList();

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final request = filtered[index];
            return BloodCardWidget(
              request: request,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RequestDetailScreen(request: request))
              ),
            );
          },
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
        final locFilter = locationFilterController.text.toLowerCase();

        final filtered = snapshot.data!.where((user) {
          final matchesSearch = user.name.toLowerCase().contains(query) ||
              user.bloodGroup.toLowerCase().contains(query) ||
              user.location.toLowerCase().contains(query);
          final matchesBlood = selectedBloodFilter == null || user.bloodGroup == selectedBloodFilter;
          final matchesLoc = locFilter.isEmpty || user.location.toLowerCase().contains(locFilter);
          return matchesSearch && matchesBlood && matchesLoc;
        }).map((user) => DonorModel.fromUserModel(user)).toList();

        if (filtered.isEmpty) return const Center(child: Text("No donors match your criteria"));

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final donor = filtered[index];
            return DonorCardWidget(
              donor: donor,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DonorDetailScreen(donor: donor))
              ),
            );
          },
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