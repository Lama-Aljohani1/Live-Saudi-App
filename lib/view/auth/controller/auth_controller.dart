import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PageController pageController = PageController();
  int currentIndex = 0;
  bool isAnimating = false;

  void switchPage(int index) async {
    if (currentIndex == index) return;
    isAnimating = true;
    currentIndex = index;
    update();
    await Future.delayed(const Duration(milliseconds: 150));
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    if (pageController.hasClients) {
      isAnimating = false;
      update();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
