import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/manage_accounts_controller.dart';

class AdminManageUsersScreen extends StatelessWidget {
  const AdminManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminUsersController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "User Management",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.3,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey[100],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        onChanged: controller.filterUsers,
                        decoration: InputDecoration(
                          hintText: "Search by name or email...",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilterChipWidget(
                      label: "All",
                      selected: controller.filter.value == "All",
                      onTap: () => controller.changeFilter("All"),
                    ),
                    FilterChipWidget(
                      label: "Tourists",
                      selected: controller.filter.value == "Tourist",
                      onTap: () => controller.changeFilter("Tourist"),
                    ),
                    FilterChipWidget(
                      label: "Guides",
                      selected: controller.filter.value == "Guide",
                      onTap: () => controller.changeFilter("Guide"),
                    ),
                    FilterChipWidget(
                      label: "Suspended",
                      selected: controller.filter.value == "Suspended",
                      onTap: () => controller.changeFilter("Suspended"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              Expanded(
                child: Obx(() {
                  final users = controller.filteredUsers;
                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        "No users found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.09),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryColor
                                  .withOpacity(0.5),
                              radius: 24.r,
                              child: Icon(
                                Icons.person,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        user.role == "Guide"
                                            ? Icons.badge
                                            : Icons.person_outline,
                                        size: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        user.role,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      controller.toggleUserStatus(user.id),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: user.isActive
                                          ? const Color(0xFFE7F6E7)
                                          : const Color(0xFFFCE4E4),
                                    ),
                                    child: Text(
                                      user.isActive ? "Active" : "Suspended",
                                      style: TextStyle(
                                        color: user.isActive
                                            ? AppColors.primaryColor
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.deleteUser(user.id),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20.sp,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: selected ? AppColors.primaryColor : Colors.grey[100],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
