class BloodRequestModel {
  final String id;
  final String bloodGroup;
  final String location;
  final String units;
  final String contact;
  final String userId;
  final int timestamp; // Unix timestamp in milliseconds

  BloodRequestModel({
    required this.id,
    required this.bloodGroup,
    required this.location,
    required this.units,
    required this.contact,
    required this.userId,
    required this.timestamp,
  });

  // ✅ Factory method
  factory BloodRequestModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return BloodRequestModel(
      id: id,
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['location'] ?? '',
      units: map['units'] ?? '',
      contact: map['contact'] ?? '',
      userId: map['userId'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  // ✅ Add isUrgent getter
  bool get isUrgent {
    final now = DateTime.now().millisecondsSinceEpoch;
    // যদি request 24 ঘন্টার ভিতরে আসে → urgent
    return (now - timestamp) <= 24 * 60 * 60 * 1000;
  }
}
