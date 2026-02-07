import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile"), centerTitle: true, leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField("Name", "Jogn Doe", Icons.person_outline),
            _buildInputField("Email", "Jogn.doe@gmail.com", Icons.lock_outline),
            _buildInputField("Phone number", "+20 123456789", Icons.phone_android),
            _buildInputField("Date of Birth", "Select Date", Icons.calendar_today),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: const Size(double.infinity, 55), shape: const StadiumBorder()),
              child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      TextField(decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)))),
      const SizedBox(height: 20),
    ],
  );
}