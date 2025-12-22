class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bloodGroup;
  final String location;
  final String phone;
  final bool isAvailable;
  final int lastDonationDate;
  final int totalDonated;
  final int totalRequests;
  final int peopleHelped;
  final int age;
  final double weight;
  final String address;
  final String? profilePic;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bloodGroup,
    required this.location,
    required this.phone,
    this.isAvailable = false,
    this.lastDonationDate = 0,
    this.totalDonated = 0,
    this.totalRequests = 0,
    this.peopleHelped = 0,
    this.age = 0,
    this.weight = 0,
    this.address = '',
    this.profilePic,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
      lastDonationDate: map['lastDonationDate'] ?? 0,
      totalDonated: map['totalDonated'] ?? 0,
      totalRequests: map['totalRequests'] ?? 0,
      peopleHelped: map['peopleHelped'] ?? 0,
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      profilePic: map['profilePic'],
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
      'profilePic': profilePic,
    };
  }
}
