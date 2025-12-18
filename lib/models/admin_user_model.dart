class AdminUserModel {
  final String id; // 🔄 صار String بدل int
  final String name;
  final String email;
  final String role; // "Tourist" or "Guide"
  final String? imagePath;
  bool isActive;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.imagePath,
    this.isActive = true,
  });

  /// ✅ لتحويل بيانات Firestore إلى كائن Dart
  factory AdminUserModel.fromFirestore(
      Map<String, dynamic> data,
      String id,
      String role,
      ) {
    return AdminUserModel(
      id: id,
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      role: role,
      imagePath: data["image"] ?? null,
      isActive: data["isActive"] ?? true, // افتراضي true إذا غير موجود
    );
  }

  /// 🔁 لتحويل الكائن إلى Map لو حبيت تحدث البيانات
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "role": role,
      "image": imagePath,
      "isActive": isActive,
    };
  }
}
