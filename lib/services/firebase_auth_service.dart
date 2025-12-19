import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // রেজিস্ট্রেশন ফাংশন (ফোন নাম্বারসহ আপডেট)
  Future<String?> registerUser({
    required String email,
    required String password,
    required String name,
    required String bloodGroup,
    required String location,
    required String phone, // নতুন
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      if (user != null) {
        // রিয়েল-টাইম ডাটাবেসে ফোন নাম্বারসহ তথ্য সেভ
        await _dbRef.child("users").child(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": email,
          "bloodGroup": bloodGroup,
          "location": location,
          "phone": phone, // ফোন নাম্বার সেভ
          "isAvailable": true,
          "createdAt": ServerValue.timestamp,
        });
        return "Success";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return "Unknown Error";
  }

  // লগইন ফাংশন
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}