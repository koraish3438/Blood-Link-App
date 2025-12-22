import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/blood_request_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final _db = FirebaseDatabase.instance.ref();

  Future<UserModel?> getUserById(String uid) async {
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

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.child('users').child(uid).update(data);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      rethrow;
    }
  }

  Future<void> updateUserAvailability(String uid, bool isAvailable) async {
    try {
      await _db.child('users').child(uid).update({'isAvailable': isAvailable});
    } catch (e) {
      debugPrint("Error updating availability: $e");
      rethrow;
    }
  }

  Stream<List<UserModel>> getDonors() {
    return _db.child('users').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map?;
      if (map == null) return [];
      return map.values
          .map((v) => UserModel.fromMap(v as Map<dynamic, dynamic>))
          .where((user) => user.isAvailable == true)
          .toList();
    });
  }

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
      final snapshot = await _db.child('users').child(request.userId).get();
      if (snapshot.exists) {
        final user = snapshot.value as Map;
        int currentRequests = (user['requests'] ?? 0) as int;
        await _db.child('users').child(request.userId).update({'requests': currentRequests + 1});
      }
    } catch (e) {
      debugPrint("Error adding blood request: $e");
      rethrow;
    }
  }

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

  Future<Map<String, int>> getUserStats(String uid) async {
    int donated = 0;
    int requests = 0;
    int helped = 0;
    try {
      final snapshot = await _db.child('users').child(uid).get();
      if (snapshot.exists) {
        final user = snapshot.value as Map;
        donated = (user['donated'] ?? 0) as int;
        requests = (user['requests'] ?? 0) as int;
        helped = donated;
      }
    } catch (e) {
      debugPrint("Error fetching user stats: $e");
    }
    return {'donated': donated, 'requests': requests, 'helped': helped};
  }

  Future<String?> updateDonationDate(String uid, int timestamp, int minDays) async {
    final snapshot = await _db.child('users').child(uid).get();
    if (!snapshot.exists) return "User not found";

    final user = snapshot.value as Map;
    int lastDonation = (user['lastDonationDate'] ?? 0) as int;

    if (lastDonation != 0) {
      final lastDate = DateTime.fromMillisecondsSinceEpoch(lastDonation);
      final now = DateTime.now();
      int diff = now.difference(lastDate).inDays;
      if (diff < minDays) {
        return "You can update after ${minDays - diff} days";
      }
    }

    int currentDonated = (user['donated'] ?? 0) as int;
    await _db.child('users').child(uid).update({
      'lastDonationDate': timestamp,
      'donated': currentDonated + 1,
      'isAvailable': false,
    });
    return "Success";
  }

  Future<void> deleteUserAccount(String uid) async {
    await _db.child('users').child(uid).remove();
    final snapshot = await _db.child('blood_requests').orderByChild('userId').equalTo(uid).get();
    for (var child in snapshot.children) {
      await child.ref.remove();
    }
  }
}