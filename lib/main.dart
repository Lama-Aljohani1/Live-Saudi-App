import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/splash/screen/splash_screen.dart';

void  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 852),
      builder: (context, child){
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Live Saudi',
            home: SplashScreen());
      },
    );
  }
}
