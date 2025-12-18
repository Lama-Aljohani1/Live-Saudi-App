import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiChatbotController extends GetxController {
  final ScrollController scroll = ScrollController();
  List<String> data = [];
  TextEditingController msgController = TextEditingController();

  static const String apiKey = "TcaX2BcdKN0hgmZvPP74l46l45doWd0PF210gVXy";
  static const String apiUrl = "https://api.cohere.com/v1/chat";

  static const String modelId = "command-a-03-2025";

  Future<void> fetchResponse(String userInput) async {
    int retries = 5;
    int delay = 2;

    while (retries > 0) {
      try {
        final response = await http
            .post(
              Uri.parse(apiUrl),
              headers: {
                "Authorization": "Bearer $apiKey",
                "Content-Type": "application/json",
              },
              body: json.encode({
                "model": modelId,
                "message": userInput,
                "temperature": 0.7,
                "max_tokens": 600,
              }),
            )
            .timeout(const Duration(seconds: 30));

        print("Raw response: ${response.body}");

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          String botReply = "";

          if (jsonData["text"] != null) {
            botReply = jsonData["text"];
          } else if (jsonData["message"] != null) {
            botReply = jsonData["message"];
          } else {
            botReply = "No response from AI.";
          }

          insertSingleItem("$botReply<bot>");
          return;
        } else if (response.statusCode == 503) {
          print("Service unavailable, retrying...");
          retries--;
          await Future.delayed(Duration(seconds: delay));
          delay *= 2; // Exponential backoff
        } else {
          insertSingleItem("⚠️ Server error: ${response.statusCode}<bot>");
          return;
        }
      } on TimeoutException catch (_) {
        print("Timeout occurred, retrying...");
        retries--;
        await Future.delayed(Duration(seconds: delay));
        delay *= 2;
      } on Exception catch (e) {
        insertSingleItem("⚠️ Exception: $e<bot>");
        print("⚠️ Exception: $e<bot>");
        return;
      }
    }

    insertSingleItem("⚠️ Unable to get response after multiple retries.<bot>");
  }

  void insertSingleItem(String message) {
    data.add(message);
    update();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
