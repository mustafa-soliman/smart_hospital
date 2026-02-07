import 'package:flutter/material.dart';

class CaseCompletedScreen extends StatelessWidget {
  const CaseCompletedScreen({super.key});

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
                const Text('Case completed', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                const SizedBox(height: 50),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF0D638F),
                  child: Icon(Icons.check, color: Colors.white, size: 60),
                ),
                const SizedBox(height: 40),
                const Text(
                  'The patient has been delivered to SHH.\nThank you for your fast response',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1B3A4B)),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Back To Home', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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