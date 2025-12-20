import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'; // এই লাইনটি debugPrint এর জন্য প্রয়োজন
import '../models/blood_request_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final _db = FirebaseDatabase.instance.ref();

  // ১. নির্দিষ্ট ইউজারের ডাটা আনা
  Future<UserModel?> getUserData(String uid) async {
    try {
      final snapshot = await _db.child('users').child(uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.value as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  // ২. প্রোফাইল এডিট/আপডেট করা
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.child('users').child(uid).update(data);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      rethrow;
    }
  }

  // ৩. ইউজারের এভেইল্যাবিলিটি আপডেট করা
  Future<void> updateUserAvailability(String uid, bool isAvailable) async {
    try {
      await _db.child('users').child(uid).update({'isAvailable': isAvailable});
    } catch (e) {
      debugPrint("Error updating availability: $e");
      rethrow;
    }
  }

  // ৪. সব রক্তদাতাদের লিস্ট আনা (লজিক: শুধুমাত্র যারা Available)
  Stream<List<UserModel>> getDonors() {
    return _db.child('users').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map?;
      if (map == null) return [];

      return map.values
          .map((v) => UserModel.fromMap(v as Map<dynamic, dynamic>))
          .where((user) => user.isAvailable == true) // ফিল্টারিং লজিক
          .toList();
    });
  }

  // ৫. নতুন রক্তের রিকোয়েস্ট পাঠানো
  Future<void> addBloodRequest(BloodRequestModel request) async {
    try {
      await _db.child('blood_requests').push().set({
        'bloodGroup': request.bloodGroup,
        'location': request.location,
        'units': request.units,
        'contact': request.contact,
        'userId': request.userId,
        'donorId': '',
        'status': 'pending',
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      debugPrint("Error adding blood request: $e");
      rethrow;
    }
  }

  // ৬. সব রিকোয়েস্টের রিয়েল-টাইম লিস্ট আনা
  Stream<List<BloodRequestModel>> getBloodRequests() {
    return _db.child('blood_requests').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map?;
      if (map == null) return [];

      return map.entries.map((e) {
        return BloodRequestModel.fromMap(
          e.key.toString(),
          e.value as Map<dynamic, dynamic>,
        );
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  // ৭. ইউজার স্ট্যাটাস (Dynamic Stats)
  Future<Map<String, int>> getUserStats(String uid) async {
    int donated = 0;
    int requests = 0;
    int helped = 0;

    try {
      final snapshot = await _db.child('blood_requests').get();
      if (snapshot.exists) {
        final map = snapshot.value as Map<dynamic, dynamic>;
        donated = map.values
            .where((v) => (v as Map)['donorId'] == uid && v['status'] == 'completed')
            .length;
        requests = map.values.where((v) => (v as Map)['userId'] == uid).length;
        helped = donated;
      }
    } catch (e) {
      debugPrint("Error fetching user stats: $e");
    }

    return {
      'donated': donated,
      'requests': requests,
      'helped': helped,
    };
  }

  // ৮. UID দিয়ে একক ইউজার fetch করা (AuthProvider এর জন্য)
  Future<Map<String, dynamic>> getUserById(String uid) async {
    try {
      final snapshot = await _db.child("users/$uid").get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return {};
    } catch (e) {
      debugPrint("Error getUserById: $e");
      return {};
    }
  }
}