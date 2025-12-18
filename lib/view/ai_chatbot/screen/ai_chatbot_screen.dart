import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';
import '../controller/ai_chatbot_controller.dart';

class AIChatbotScreen extends StatelessWidget {
  const AIChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiChatbotController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chatbot AI',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<AiChatbotController>(
                builder: (_) {
                  return controller.data.isEmpty
                      ? _welcomeScreen()
                      : _chatList(controller);
                },
              ),
            ),
            _inputBar(controller),
          ],
        ),
      ),
    );
  }

  Widget _welcomeScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.ai, width: 150.w, height: 150.w),
            SizedBox(height: 20.h),
            Text(
              'Hello, how can I help you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatList(AiChatbotController controller) {
    return ListView.builder(
      controller: controller.scroll,
      padding: EdgeInsets.all(16.w),
      itemCount: controller.data.length,
      itemBuilder: (_, i) {
        final msg = controller.data[i];
        final mine = msg.endsWith("<bot>");

        return Align(
          alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: mine ? Colors.grey.shade200 : AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              msg.replaceAll("<bot>", ""),
              style: TextStyle(
                color: mine ? Colors.black87 : Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputBar(AiChatbotController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.msgController,
              decoration: InputDecoration(
                hintText: "Write your message...",
                hintStyle: TextStyle(fontSize: 13.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              onSubmitted: (msg) async {
                if (msg.trim().isNotEmpty) {
                  controller.insertSingleItem(msg.trim());
                  await controller.fetchResponse(msg.trim());
                  controller.msgController.clear();
                }
              },
            ),
          ),

          SizedBox(width: 8.w),

          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                final msg = controller.msgController.text.trim();
                if (msg.isNotEmpty) {
                  controller.insertSingleItem(msg);
                  await controller.fetchResponse(msg);
                  controller.msgController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
