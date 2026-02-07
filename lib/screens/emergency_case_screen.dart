import 'package:flutter/material.dart';
// استيراد الصفحة الجديدة
import 'package:smart_hospital/screens/patient_details_screen.dart';

class EmergencyCaseScreen extends StatelessWidget {
  const EmergencyCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Emergency Case',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      // الانتقال لصفحة بيانات المريض
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PatientDetailsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'Start New Case',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Emergency requests are sent securely.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF1B3A4B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}