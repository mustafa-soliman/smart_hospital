import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/set_new_password_screen.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.4)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Password reset', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 15),
                  const Text('Your password has been successfully reset.\nclick confirm to set a new password.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SetNewPasswordScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: const Size(double.infinity, 60), shape: const StadiumBorder()),
                    child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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