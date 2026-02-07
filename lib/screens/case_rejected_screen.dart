import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/nearby_hospital_screen.dart';

class CaseRejectedScreen extends StatelessWidget {
  const CaseRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. استدعاء الخلفية الموحدة hospital_bg.png
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
          ),
          // طبقة شفافة لتحسين وضوح العناصر
          Container(color: Colors.white.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // زر الرجوع العلوي
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // عنوان الصفحة
                  const Text(
                    'Case Rejected',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // أيقونة الرفض (X باللون الأحمر) كما في التصميم
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 50),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // نصوص التوضيح الخاصة بالرفض
                  const Text(
                    'The hospital cannot receive this patient',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No available beds at SHH Hospital',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // زر اقتراح مستشفيات قريبة (Suggest Nearby Hospitals)
                  ElevatedButton(
                    onPressed: () {
                      // الانتقال لصفحة المستشفيات البديلة
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NearbyHospitalScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Suggest Nearby Hospitals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}