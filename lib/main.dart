import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // এই ইমপোর্টটি নিশ্চিত করুন
import 'firebase_options.dart';
import 'utils/app_colors.dart';
import 'utils/app_constants.dart';
import 'providers/auth_provider.dart'; // আপনার AuthProvider ইমপোর্ট করুন
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // MultiProvider কে সবার উপরে (Root) রাখতে হবে
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // এখানে অন্য প্রোভাইডার থাকলে যোগ করবেন (যেমন: BloodProvider)
      ],
      child: const BloodLinkApp(),
    ),
  );
}

class BloodLinkApp extends StatelessWidget {
  const BloodLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}