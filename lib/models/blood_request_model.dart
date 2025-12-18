class BloodRequestModel {
  final String id;
  final String bloodGroup;
  final String location;
  final String units;
  final String contact;
  final String userId;
  final int timestamp;

  BloodRequestModel({
    required this.id,
    required this.bloodGroup,
    required this.location,
    required this.units,
    required this.contact,
    required this.userId,
    required this.timestamp,
  });

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
}