import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;

  // ✅ Updated logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null; // clear user locally
      notifyListeners();
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}
