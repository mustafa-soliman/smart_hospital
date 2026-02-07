import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_hospital/screens/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. الأنيميشن اللي بيخلي اللوجو يظهر بالتدريج
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // 2. الانتقال لصفحة اختيار الأدوار بعد 3 ثواني
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية المستشفى - استخدمنا hospital_bg لأنها اللي شغالة في صفحة الأدوار
          Image.asset(
            'assets/images/hospital_background.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.white); // لو الصورة متمسحتش يظهر أبيض بدل خطأ أحمر
            },
          ),

          // المحتوى في المنتصف (اللوجو والأسماء)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوجو المستشفى
                Image.asset(
                  'assets/images/shh_logo.png',
                  width: 180,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.local_hospital, size: 100, color: Color(0xFF1B3A4B)),
                ),
                const SizedBox(height: 25),
                // الاسم بالعربي باللون الكحلي الموحد
                const Text(
                  'مستشفى الحياة الذكية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A4B),
                  ),
                ),
                const SizedBox(height: 5),
                // الاسم بالإنجليزي
                const Text(
                  'SMART HAYAT HOSPITAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B3A4B),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}