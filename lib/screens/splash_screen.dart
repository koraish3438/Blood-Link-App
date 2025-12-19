import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkAuthAndNavigate();
  }

  // লোগো এবং টেক্সটের জন্য ফেড-ইন অ্যানিমেশন
  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  // ২ সেকেন্ড পর লগইন স্টেট চেক করে নেভিগেট করার লজিক
  void _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Firebase Auth সরাসরি চেক করা হচ্ছে Persistence নিশ্চিত করতে
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // ইউজার লগইন থাকলে হোম স্ক্রিনে যাবে
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // লগইন না থাকলে লগইন স্ক্রিনে যাবে
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ব্যাকগ্রাউন্ড লাল
      backgroundColor: AppColors.primaryRed,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1), // ১ সেকেন্ড ধরে ফেড-ইন হবে
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ব্লাড-ড্রপ লোগো
              const Icon(
                Icons.bloodtype,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              // অ্যাপের নাম
              Text(
                AppConstants.appName,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              // ট্যাগলাইন
              const Text(
                "Connecting donors, saving lives",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}