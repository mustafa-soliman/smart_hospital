import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/sign_in_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool _isObscure = true;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(radius: 40, backgroundColor: Color(0xFFE8F1F5)),
                    Icon(Icons.check_circle, color: Color(0xFF1B3A4B), size: 60),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Password Update Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A4B),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A4B),
                    minimumSize: const Size(double.infinity, 55),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Back To Sign in",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          Container(color: Colors.white.withOpacity(0.5)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBackButton(),
                  const SizedBox(height: 30),
                  const Text(
                    'Set a new password',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create a new password. Ensure it differs from previous ones for security',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 40),

                  // حقول الإدخال
                  _buildInputField("Password", "************"),
                  const SizedBox(height: 25),
                  _buildInputField("Confirm Password", "************"),

                  const SizedBox(height: 40),

                  // زر التحديث النهائي
                  ElevatedButton(
                    onPressed: _showSuccessDialog, // استدعاء الـ Pop-up
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Update Password',
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

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_back_ios_new, size: 20),
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 10),
        TextField(
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}