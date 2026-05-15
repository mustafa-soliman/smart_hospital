import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/PatientMainScreen.dart'; // تأكد من استيراد ملف شاشة المريض الرئيسية

void showPaymentStatusDialog(BuildContext context, bool isSuccess) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة الحالة (سواء نجاح أو فشل)
            _buildStatusIcon(isSuccess),
            const SizedBox(height: 25),
            Text(
              isSuccess ? 'Payment Successful!' : 'Payment Failed',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // زر العودة للهوم
            ElevatedButton(
              onPressed: () {
                // هذا الكود يغلق كل الصفحات ويفتح شاشة المريض الرئيسية (MainScreen)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientMainScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A394A),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStatusIcon(bool isSuccess) {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: isSuccess ? Colors.blue[50] : Colors.red[50],
      shape: BoxShape.circle,
    ),
    child: Icon(
      isSuccess ? Icons.check_circle : Icons.error,
      color: isSuccess ? Colors.blue : Colors.red,
      size: 60,
    ),
  );
}