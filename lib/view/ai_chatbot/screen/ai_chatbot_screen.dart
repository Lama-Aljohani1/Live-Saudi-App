import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController ctrl = TextEditingController();
  final ScrollController sc = ScrollController();

  bool get isChatStarted => messages.isNotEmpty;

  void send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({'from': 'user', 'text': text});
    });
    ctrl.clear();

    // simulated bot response
    Future.delayed(const Duration(milliseconds: 600), () {
      final response = _generateReply(text);
      setState(() {
        messages.add({'from': 'bot', 'text': response});
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        sc.animateTo(
          sc.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String _generateReply(String q) {
    final lc = q.toLowerCase();
    if (lc.contains('hours') || lc.contains('open')) {
      return 'The site is open from 9:00 AM to 6:00 PM daily.';
    }
    if (lc.contains('price')) {
      return 'Entry fee is SAR 20 per person. Guided tours may vary.';
    }
    if (lc.contains('best time')) {
      return 'Early morning or late afternoon are great to avoid heat and crowds.';
    }
    return 'Great question — this site is known for its heritage and architecture. Would you like recommendations or a short tour plan?';
  }

  @override
  Widget build(BuildContext context) {
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
              child: isChatStarted ? _buildChatList() : _buildWelcomeScreen(),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // شاشة الترحيب
  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.ai,
              width: 150.w,
              height: 150.w,
            ),
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

  // واجهة الدردشة
  Widget _buildChatList() {
    return ListView.builder(
      controller: sc,
      padding: EdgeInsets.all(16.w),
      itemCount: messages.length,
      itemBuilder: (_, i) {
        final m = messages[i];
        final isBot = m['from'] == 'bot';
        return Align(
          alignment:
          isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isBot
                  ? Colors.grey.shade200
                  : AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              m['text'],
              style: TextStyle(
                color: isBot ? Colors.black87 : Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  // شريط الإدخال السفلي
  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: 'Generate a name or ask about the site...',
                hintStyle: TextStyle(fontSize: 13.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              onSubmitted: send,
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => send(ctrl.text),
            ),
          ),
        ],
      ),
    );
  }
}
