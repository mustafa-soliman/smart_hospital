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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Case completed',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 40),
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFF0D638F),
                    child: Icon(Icons.check, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'The patient has been delivered to SHH .\nThank you for your fast response',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B3A4B), height: 1.5),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Back To Home',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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