class GuideRequestModel {
  final String id;
  final String name;
  final String email;
  final String licenseId;
  final int experienceYears;
  final String country;
  final List<String> languages;
  final String? imagePath;
  final String? identityImagePath;
  final bool isApproved;

  GuideRequestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.licenseId,
    required this.experienceYears,
    required this.country,
    required this.languages,
    this.imagePath,
    this.identityImagePath,
    this.isApproved = false,
  });

  factory GuideRequestModel.fromFirestore(Map<String, dynamic> data, String id) {
    return GuideRequestModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      licenseId: data['licenseId'] ?? '',
      experienceYears: data['experienceYears'] ?? 0,
      country: data['country'] ?? '',
      languages: List<String>.from(data['languages'] ?? []),
      imagePath: data['image'] ?? null,
      identityImagePath: data['identityImage'] ?? null,
      isApproved: data['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'licenseId': licenseId,
      'experienceYears': experienceYears,
      'country': country,
      'languages': languages,
      'image': imagePath,
      'identityImage': identityImagePath,
      'isApproved': isApproved,
    };
  }
}
