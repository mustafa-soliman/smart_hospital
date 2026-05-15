import 'package:flutter/material.dart';

class PasswordManagerScreen extends StatelessWidget {
  const PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Password Manager",
          style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordSlot("Current Password"),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password ?", style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            _buildPasswordSlot("New Password"),
            const SizedBox(height: 20),
            _buildPasswordSlot("Confirm New Password"),
            const SizedBox(height: 60),

            // Change Password Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3A4B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // Fully rounded like image
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSlot(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: true,
          initialValue: "************",
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black, size: 22),
            suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.black, size: 22),
            filled: true,
            fillColor: const Color(0xFFFBFBFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
          ),
        ),
      ],
    );
  }
}