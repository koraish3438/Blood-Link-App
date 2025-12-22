class DonorModel {
  final String id;
  final String name;
  final String bloodGroup;
  final String location;
  final String phone;
  final bool isAvailable;

  DonorModel({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.phone,
    required this.isAvailable,
  });

  factory DonorModel.fromUserModel(dynamic user) {
    return DonorModel(
      id: user.uid ?? '',
      name: user.name ?? 'Unknown',
      bloodGroup: user.bloodGroup ?? 'N/A',
      location: user.location ?? 'No Location',
      phone: user.phone ?? '',
      isAvailable: user.isAvailable ?? false,
    );
  }
}