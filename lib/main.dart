import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/splash_screen.dart'; // تأكد من إنشاء هذا الملف

void main() {
  runApp(const SmartHayatHospitalApp());
}

class SmartHayatHospitalApp extends StatelessWidget {
  const SmartHayatHospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // لإخفاء شريط الـ Debug المزعج في الزاوية
      debugShowCheckedModeBanner: false,

      title: 'Smart Hayat Hospital',

      // ثيم التطبيق الموحد بالألوان التي اخترناها (الأزرق الداكن)
      theme: ThemeData(
        primaryColor: const Color(0xFF1B3A4B),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B3A4B)),
        useMaterial3: true,
        fontFamily: 'Roboto', // أو أي خط تفضله
      ),

      // نقطة البداية: شاشة الـ Splash التي تحتوي على تصميم المبنى واللوجو
      home: const SplashScreen(),
    );
  }
}