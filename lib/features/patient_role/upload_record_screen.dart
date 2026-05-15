import 'package:flutter/material.dart';

class UploadRecordScreen extends StatelessWidget {
  const UploadRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFFF1F4F7),
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upload Record', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4A90E2), width: 1.5),
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF8FBFF),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE8F1F9),
                    child: Icon(Icons.cloud_upload_outlined, color: Color(0xFF4A90E2)),
                  ),
                  SizedBox(height: 15),
                  Text('Tap to upload or drag and drop', style: TextStyle(color: Color(0xFF0056B3), fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 5),
                  Text('PDF, JPG, PNG (Max 10MB)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Record Title', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Blood Test Result Oct 2023',
                filled: true,
                fillColor: const Color(0xFFE9ECEF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            const Text('SELECTED FILES', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/default_avatar.png', width: 40, height: 40),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('blood_test_result.pdf', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('1.2 MB', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.delete_outline, color: Colors.red),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A394A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Upload Record', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}