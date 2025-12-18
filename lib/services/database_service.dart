import 'package:firebase_database/firebase_database.dart';
import '../models/blood_request_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  // ডাটাবেস রেফারেন্স তৈরি
  final _db = FirebaseDatabase.instance.ref();

  // ১. নির্দিষ্ট ইউজারের ডাটা আনা (Profile Screen-এর জন্য)
  Future<UserModel?> getUserData(String uid) async {
    try {
      final snapshot = await _db.child('users').child(uid).get();
      if (snapshot.exists) {
        // ডাটাবেস থেকে পাওয়া ম্যাপটিকে UserModel-এ কনভার্ট করা
        return UserModel.fromMap(snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // ২. সব রক্তদাতাদের লিস্ট আনা (Donors List)
  Stream<List<UserModel>> getDonors() {
    return _db.child('users').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map?;
      if (map == null) return [];

      return map.values
          .map((v) => UserModel.fromMap(v as Map<dynamic, dynamic>))
          .toList();
    });
  }

  // ৩. নতুন রক্তের রিকোয়েস্ট পাঠানো (Request Blood)
  Future<void> addBloodRequest(BloodRequestModel request) async {
    try {
      await _db.child('blood_requests').push().set({
        'bloodGroup': request.bloodGroup,
        'location': request.location,
        'units': request.units,
        'contact': request.contact,
        'userId': request.userId,
        'timestamp': ServerValue.timestamp, // সার্ভার টাইমস্ট্যাম্প
      });
    } catch (e) {
      print("Error adding blood request: $e");
      rethrow;
    }
  }

  // ৪. সব রক্তের রিকোয়েস্টের রিয়েল-টাইম লিস্ট আনা (Home Screen-এর জন্য)
  Stream<List<BloodRequestModel>> getBloodRequests() {
    return _db.child('blood_requests').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map?;
      if (map == null) return [];

      // ম্যাপ এন্ট্রিগুলোকে BloodRequestModel-এর লিস্টে রূপান্তর
      return map.entries.map((e) {
        return BloodRequestModel.fromMap(
            e.key.toString(), // এন্ট্রির কী হচ্ছে রিকোয়েস্ট আইডি
            e.value as Map<dynamic, dynamic>
        );
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // লেটেস্ট রিকোয়েস্ট উপরে দেখাবে
    });
  }
}