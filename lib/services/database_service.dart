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
        'donorId': request.userId, // optional, adjust if needed
        'timestamp': ServerValue.timestamp,
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

      return map.entries.map((e) {
        return BloodRequestModel.fromMap(
            e.key.toString(),
            e.value as Map<dynamic, dynamic>
        );
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  // ✅ ৫. getUserStats (Dynamic Profile stats)
  Future<Map<String, int>> getUserStats(String uid) async {
    int donated = 0;
    int requests = 0;
    int followers = 0;

    try {
      // Donated = where donorId == uid
      final donatedSnap = await _db.child('blood_requests').get();
      if (donatedSnap.exists) {
        final map = donatedSnap.value as Map<dynamic, dynamic>;
        donated = map.values
            .where((v) => (v as Map)['donorId'] == uid)
            .length;
      }

      // Requests = where userId == uid
      final requestsSnap = await _db.child('blood_requests').get();
      if (requestsSnap.exists) {
        final map = requestsSnap.value as Map<dynamic, dynamic>;
        requests = map.values
            .where((v) => (v as Map)['userId'] == uid)
            .length;
      }

      // Followers = assuming followers stored in 'followers' node
      final followersSnap = await _db.child('followers').child(uid).get();
      if (followersSnap.exists) {
        final map = followersSnap.value as Map<dynamic, dynamic>;
        followers = map.length;
      }

    } catch (e) {
      print("Error fetching user stats: $e");
    }

    return {
      'donated': donated,
      'requests': requests,
      'followers': followers,
    };
  }
}
