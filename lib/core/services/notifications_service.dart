import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String serverKey = "AAAAxxxxxxxxxxxxxxxxxxxx"; // مفتاح FCM من Firebase

Future<void> sendBookingNotification({
  required String userId,
  required String title,
  required String body,
}) async {
  final userDoc =
  await FirebaseFirestore.instance.collection("Users").doc(userId).get();

  if (!userDoc.exists || userDoc["fcmToken"] == null) return;

  final token = userDoc["fcmToken"];

  final data = {
    "to": token,
    "notification": {
      "title": title,
      "body": body,
      "sound": "default",
    },
    "priority": "high",
  };

  await http.post(
    Uri.parse("https://fcm.googleapis.com/fcm/send"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "key=$serverKey",
    },
    body: jsonEncode(data),
  );
}
