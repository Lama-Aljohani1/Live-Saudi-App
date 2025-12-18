import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/admin_manage_heritage_controller.dart';
import '../widget/manage_heritage_tab.dart';
import '../widget/heritage_map_tab.dart';
import '../widget/add_heritage_dialog.dart';

class AdminManageHeritageScreen extends StatefulWidget {
  const AdminManageHeritageScreen({super.key});

  @override
  State<AdminManageHeritageScreen> createState() =>
      _AdminManageHeritageScreenState();
}

class _AdminManageHeritageScreenState extends State<AdminManageHeritageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(AdminManageHeritageController());
  bool showFab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging)
        setState(() => showFab = _tabController.index == 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: const [ManageHeritageTab(), HeritageMapTab()],
      ),
      floatingActionButton: showFab
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => Get.dialog(const AddHeritageDialog()),
                backgroundColor: AppColors.primaryColor,
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Add Site',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.white),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          padding: EdgeInsets.all(6.w),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(icon: Icon(Icons.list_alt_rounded), text: 'Sites'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Map'),
            ],
          ),
        ),
      ),
    );
  }
}
