class DonorModel {
  final String id;
  final String name;
  final String bloodGroup;
  final String location;
  final String phone;
  final bool isAvailable;
  final String? email;
  final int age;
  final int weight;
  final int lastDonationDate;
  final String address;
  final String? profilePic;

  DonorModel({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.phone,
    required this.isAvailable,
    this.email,
    required this.age,
    required this.weight,
    required this.lastDonationDate,
    required this.address,
    this.profilePic,
  });

  factory DonorModel.fromUserModel(dynamic user) {
    return DonorModel(
      id: user.uid,
      name: user.name,
      bloodGroup: user.bloodGroup,
      location: user.location,
      phone: user.phone,
      isAvailable: user.isAvailable,
      email: user.email,
      age: (user.age is double) ? (user.age as double).toInt() : user.age,
      weight: (user.weight is double) ? (user.weight as double).toInt() : user.weight,
      lastDonationDate: (user.lastDonationDate is double) ? (user.lastDonationDate as double).toInt() : user.lastDonationDate,
      address: user.address,
      profilePic: user.profilePic,
    );
  }
}
