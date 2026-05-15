import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  final String userRole;
  const SignUpScreen({super.key, required this.userRole});

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
                  const SizedBox(height: 40),
                  const Text('Sign Up', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 30),
                  _buildField("Name", Icons.person_outline, "Jogn Doe"),
                  const SizedBox(height: 15),
                  _buildField("Email", Icons.email_outlined, "jogn.doe@gmail.com"),
                  const SizedBox(height: 15),
                  _buildField("Password", Icons.lock_outline, "************", isPass: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(userRole: userRole))
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3A4B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: const StadiumBorder()
                    ),
                    child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Sign In", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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

  Widget _buildField(String label, IconData icon, String hint, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 8),
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