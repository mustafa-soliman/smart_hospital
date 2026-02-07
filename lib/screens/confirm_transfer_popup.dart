import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/transfer_completed_screen.dart';

class ConfirmTransferPopup extends StatelessWidget {
  const ConfirmTransferPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // لجعل الخلفية تبدو كمنبثق
      body: Stack(
        children: [
          // خلفية معتمة قليلاً لتركيز الانتباه على المنبثق
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black54),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة التحذير أو التأكيد
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE8F1F5),
                    child: Icon(
                      Icons.swap_horiz_rounded,
                      color: Color(0xFF1B3A4B),
                      size: 45,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Confirm Transfer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Are you sure you want to transfer this patient to Hospital A?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // أزرار التحكم
                  Row(
                    children: [
                      // زر الإلغاء
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B3A4B)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      // زر التأكيد والانتقال
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // الانتقال لصفحة النجاح (Transfer Completed)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransferCompletedScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B3A4B),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Transfer',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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