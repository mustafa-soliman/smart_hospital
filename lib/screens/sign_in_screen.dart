import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/sign_up_screen.dart';
import 'package:smart_hospital/screens/home_screen.dart';
import 'package:smart_hospital/screens/forgot_password_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.5)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text('Sign In', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 40),
                  _buildTextField("Email", Icons.email_outlined, "jogn.doe@gmail.com"),
                  const SizedBox(height: 20),
                  _buildTextField("Password", Icons.lock_outline, "************", isPass: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                      child: const Text('Forgot Password ?', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // الربط بصفحة الـ Home
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: const Size(double.infinity, 60), shape: const StadiumBorder()),
                    child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ? "),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                        child: const Text("Sign Up", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(String label, IconData icon, String hint, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 10),
        TextField(
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}