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
        final userModel = await DatabaseService().getUserById(firebaseUser.uid);
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

  Future<void> deleteAccountPermanently() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      String uid = currentUser.uid;

      await DatabaseService().deleteUserAccount(uid);

      await currentUser.delete();

      _userModel = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw "For security, please logout and login again to delete your account.";
      }
      throw e.message ?? "An error occurred";
    } catch (e) {
      throw e.toString();
    }
  }
}