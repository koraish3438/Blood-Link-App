class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bloodGroup;
  final String location;
  final String phone;
  final bool isAvailable;

  // নতুন ফিল্ডস
  final int lastDonationDate; // Timestamp in milliseconds
  final int totalDonated;
  final int totalRequests;
  final int peopleHelped;

  // Optional professional profile fields
  final int age;
  final double weight; // kg
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bloodGroup,
    required this.location,
    required this.phone,
    this.isAvailable = true,
    this.lastDonationDate = 0,
    this.totalDonated = 0,
    this.totalRequests = 0,
    this.peopleHelped = 0,
    this.age = 0,
    this.weight = 0,
    this.address = '',
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      lastDonationDate: map['lastDonationDate'] ?? 0,
      totalDonated: map['totalDonated'] ?? 0,
      totalRequests: map['totalRequests'] ?? 0,
      peopleHelped: map['peopleHelped'] ?? 0,
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bloodGroup': bloodGroup,
      'location': location,
      'phone': phone,
      'isAvailable': isAvailable,
      'lastDonationDate': lastDonationDate,
      'totalDonated': totalDonated,
      'totalRequests': totalRequests,
      'peopleHelped': peopleHelped,
      'age': age,
      'weight': weight,
      'address': address,
    };
  }
}
