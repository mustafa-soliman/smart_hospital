import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_hospital/screens/splash_screen.dart';
// استيراد الملفات الجديدة للربط
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/main_layout.dart';
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/home_doctor_screen.dart';

void main() {
  runApp(const SmartHayatHospitalApp());
}

class SmartHayatHospitalApp extends StatelessWidget {
  const SmartHayatHospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Hayat Hospital',
          theme: ThemeData(
            primaryColor: const Color(0xFF1B3A4B),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B3A4B)),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          // البداية هتكون الـ SplashScreen زي ما هي
          home: const SplashScreen(),
          // ضفت لك الـ Routes هنا عشان التنقل يكون أسهل في البرنامج كله
          routes: {
            '/main_layout': (context) => const MainLayout(),
            '/home': (context) => const HomeDoctorScreen(),
          },
        );
      },
    );
  }
}