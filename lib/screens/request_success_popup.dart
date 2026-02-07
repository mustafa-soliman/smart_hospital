import 'package:flutter/material.dart';

class RequestSuccessPopup extends StatelessWidget {
  const RequestSuccessPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء سادة
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF0D638F), size: 80),
                const SizedBox(height: 25),
                const Text(
                  'Request Submitted Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Your login ID will be sent to your\nphone number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // العودة لصفحة تسجيل الدخول مباشرة
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A4B),
                    minimumSize: const Size(150, 50),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}