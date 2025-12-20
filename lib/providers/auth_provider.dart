import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _userModel;
  UserModel? get user => _userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        // Firebase থেকে UserModel load করা
        final userMap = await DatabaseService().getUserById(firebaseUser.uid);
        _userModel = UserModel.fromMap(userMap);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  bool get isAuthenticated => _userModel != null;

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}
