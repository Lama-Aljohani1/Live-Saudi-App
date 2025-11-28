import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/admin_user_model.dart';

class AdminUsersController extends GetxController {
  var users = <AdminUserModel>[].obs;
  var filter = "All".obs;
  var searchQuery = "".obs;
  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// 🟢 تحميل جميع المستخدمين من Firestore
  Future<void> fetchUsers() async {
    users.clear();
    try {
      final touristsSnapshot = await _db.collection("Tourist").get();
      final guidesSnapshot = await _db.collection("TourGuide").get();

      final allUsers = [
        ...touristsSnapshot.docs.map((doc) =>
            AdminUserModel.fromFirestore(doc.data(), doc.id, "Tourist")),
        ...guidesSnapshot.docs.map((doc) =>
            AdminUserModel.fromFirestore(doc.data(), doc.id, "Guide")),
      ];

      users.assignAll(allUsers);
    } catch (e) {
      print("❌ Error fetching users: $e");
    }
  }

  void changeFilter(String newFilter) => filter.value = newFilter;
  void filterUsers(String query) => searchQuery.value = query.toLowerCase();

  /// 🔍 فلترة حسب الدور والبحث
  List<AdminUserModel> get filteredUsers {
    return users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(searchQuery.value) ||
          user.email.toLowerCase().contains(searchQuery.value);

      final matchesFilter = filter.value == "All" ||
          (filter.value == "Tourist" && user.role == "Tourist") ||
          (filter.value == "Guide" && user.role == "Guide") ||
          (filter.value == "Suspended" && !user.isActive);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  /// 🟠 تفعيل / تعليق المستخدم
  Future<void> toggleUserStatus(String id) async {
    final index = users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final user = users[index];
      final collection = user.role == "Tourist" ? "Tourist" : "TourGuide";
      final newStatus = !user.isActive;

      try {
        await _db.collection(collection).doc(id).update({"isActive": newStatus});
        user.isActive = newStatus;
        users.refresh();
      } catch (e) {
        print("⚠️ Error toggling status: $e");
      }
    }
  }

  /// 🔴 حذف المستخدم نهائيًا
  Future<void> deleteUser(String id) async {
    final index = users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final user = users[index];
      final collection = user.role == "Tourist" ? "Tourist" : "TourGuide";

      try {
        await _db.collection(collection).doc(id).delete();
        users.removeAt(index);
      } catch (e) {
        print("⚠️ Error deleting user: $e");
      }
    }
  }
}
