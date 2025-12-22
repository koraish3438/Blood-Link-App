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
        final userModel =
        await DatabaseService().getUserData(firebaseUser.uid);
        _userModel = userModel;
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  bool get isAuthenticated => _userModel != null;

  Future<void> logout() async {
    await _auth.signOut();
    _userModel = null;
    notifyListeners();
  }
}
