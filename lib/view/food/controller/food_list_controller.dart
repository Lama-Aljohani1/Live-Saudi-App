import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> streamFoodAccounts() {
    return _db
        .collection('foodAccounts')
        .orderBy('verified', descending: true)
        .snapshots();
  }
}
