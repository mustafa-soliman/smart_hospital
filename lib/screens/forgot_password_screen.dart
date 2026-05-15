import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/verify_code_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  // 1. إضافة المتغير لاستقبال الـ Role
  final String userRole;
  const ForgotPasswordScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
          ),
          Container(color: Colors.white.withOpacity(0.4)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Forgot password',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your email to reset the password',
                    style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "jogn.doe@gmail.com",
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // 2. التعديل هنا: تمرير الـ userRole لصفحة الـ Verify Code
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerifyCodeScreen(userRole: userRole)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Reset Password',
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