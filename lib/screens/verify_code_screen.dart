import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/password_reset_success_screen.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String userRole; // إضافة المتغير
  const VerifyCodeScreen({super.key, required this.userRole}); // تحديث الـ Constructor

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
                  _buildBackButton(context),
                  const SizedBox(height: 40),
                  const Text('Check your email', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 10),
                  const Text('We sent a reset link to jogn.doe@gmail.com\nenter 5 digit code that mentioned in the email', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) => _buildCodeBox(context)),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    // التعديل هنا: تمرير الـ userRole لصفحة النجاح
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetSuccessScreen(userRole: userRole))),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: const Size(double.infinity, 60), shape: const StadiumBorder()),
                    child: const Text('Verify Code', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        text: "Haven’t got the email yet ? ",
                        style: TextStyle(color: Colors.black),
                        children: [TextSpan(text: "Resend email", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
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

  Widget _buildCodeBox(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(counterText: "", border: InputBorder.none),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios_new, size: 20)),
    );
  }
}