import 'package:cloud_firestore/cloud_firestore.dart';

class HeritageModel {
  final String id;
  final String name;
  final String region;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> imagesBase64;
  final double pricePerPerson;
  final double rating;
  final List<Map<String, dynamic>> reviews;
  final String category; // ✅ التصنيف الجديد

  HeritageModel({
    required this.id,
    required this.name,
    required this.region,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imagesBase64,
    required this.pricePerPerson,
    required this.rating,
    required this.reviews,
    required this.category,
  });

  factory HeritageModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final imgs = <String>[];
    if (data['images'] != null && data['images'] is List) {
      for (var it in data['images']) {
        if (it is String) imgs.add(it);
      }
    }
    return HeritageModel(
      id: doc.id,
      name: data['name'] ?? '',
      region: data['region'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      imagesBase64: imgs,
      pricePerPerson: (data['pricePerPerson'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: (data['reviews'] != null && data['reviews'] is List)
          ? List<Map<String, dynamic>>.from(data['reviews'])
          : <Map<String, dynamic>>[],
      category: data['category'] ?? 'popular',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'images': imagesBase64,
      'pricePerPerson': pricePerPerson,
      'rating': rating,
      'reviews': reviews,
      'category': category,
    };
  }
}
