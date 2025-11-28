import 'package:cloud_firestore/cloud_firestore.dart';

class TourGuideModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isApproved;
  final int experienceYears;
  final String country;
  final List<String> languages;
  final String hourlyRate;
  final String instagram;
  final String whatsappNumber;
  final Timestamp? createdAt;

  TourGuideModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.isApproved,
    required this.experienceYears,
    required this.country,
    required this.languages,
    this.hourlyRate ='',
    this.instagram = '',
    this.whatsappNumber = '',
    this.createdAt,
  });

  factory TourGuideModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};

    return TourGuideModel(
      uid: d['uid'] ?? doc.id,
      name: d['name'] ?? '',
      email: d['email'] ?? '',
      phone: d['phone'] ?? '',
      isApproved: d['isApproved'] ?? false,
      experienceYears: d['experienceYears'] ?? 0,
      country: d['country'] ?? '',
      languages: d['languages'] != null ? List<String>.from(d['languages']) : [],
      hourlyRate: (d['hourlyRate'] != null)
          ? (d['hourlyRate'] )
          :"",
      instagram: d['instagram'] ?? '',
      whatsappNumber: d['whatsappNumber'] ?? '',
      createdAt: d['createdAt'],
    );
  }
}
