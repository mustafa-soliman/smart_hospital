import 'package:flutter/material.dart';
// استيراد صفحة النجاح ليتمكن الكود من الانتقال إليها
import 'package:smart_hospital/screens/request_success_popup.dart';

class ContactAdminScreen extends StatelessWidget {
  const ContactAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // تعريف الباك جراوند في الكود
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    const Text(
                      'Contact Admin',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                    ),
                    const SizedBox(height: 40),
                    _buildField('Name', 'Enter your Name', Icons.person_outline),
                    const SizedBox(height: 20),
                    _buildField('Phone', 'Enter your Phone Number', Icons.phone_outlined),
                    const SizedBox(height: 20),
                    _buildField('Message', 'Write your request or note', Icons.chat_bubble_outline, maxLines: 4),
                    const SizedBox(height: 40),

                    // الزر الذي ينقلك لصفحة النجاح
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RequestSuccessPopup()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3A4B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Send Request',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 10),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF1B3A4B)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}