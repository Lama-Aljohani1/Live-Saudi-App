import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String touristId;
  final String touristName;
  final String guideId;
  final String guideName;
  final DateTime date;
  final String time;
  final int pax;
  final String siteId;
  final String siteName;
  final String status;
  final String notes;
  final Timestamp createdAt;
  final bool isApprovedForCommunication;

  BookingModel({
    required this.id,
    required this.touristId,
    required this.touristName,
    required this.guideId,
    required this.guideName,
    required this.date,
    required this.time,
    required this.pax,
    required this.siteId,
    required this.siteName,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.isApprovedForCommunication,
  });

  factory BookingModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.tryParse(data['date']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return BookingModel(
      id: doc.id,
      touristId: data['touristId'] ?? '',
      touristName: data['touristName'] ?? '',
      guideId: data['guideId'] ?? '',
      guideName: data['guideName'] ?? '',
      date: parsedDate,
      time: data['time'] ?? '',
      pax: (data['pax'] ?? 1),
      siteId: data['siteId'] ?? '',
      siteName: data['siteName'] ?? '',
      status: data['status'] ?? 'pending',
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isApprovedForCommunication: data['isApprovedForCommunication'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'touristId': touristId,
      'touristName': touristName,
      'guideId': guideId,
      'guideName': guideName,
      'date': Timestamp.fromDate(date),
      'time': time,
      'pax': pax,
      'siteId': siteId,
      'siteName': siteName,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
      'isApprovedForCommunication': isApprovedForCommunication,
    };
  }
}
