class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bloodGroup;
  final String location;
  final bool isAvailable;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bloodGroup,
    required this.location,
    this.isAvailable = true,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['location'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bloodGroup': bloodGroup,
      'location': location,
      'isAvailable': isAvailable,
    };
  }
}