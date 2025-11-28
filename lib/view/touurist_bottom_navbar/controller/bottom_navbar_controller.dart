// lib/view/touurist_bottom_navbar/controller/bottom_navbar_controller.dart
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  int selectedIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    update();
  }
}
