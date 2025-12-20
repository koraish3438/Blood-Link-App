class DonorModel {
  final String name;
  final String bloodGroup;
  final String location;
  final bool isAvailable;

  DonorModel({
    required this.name,
    required this.bloodGroup,
    required this.location,
    this.isAvailable = true,
  });

  // Optional: Convert UserModel → DonorModel
  factory DonorModel.fromUserModel(user) {
    return DonorModel(
      name: user.name,
      bloodGroup: user.bloodGroup,
      location: user.location,
      isAvailable: user.isAvailable,
    );
  }
}
