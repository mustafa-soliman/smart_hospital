import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/upload_record_screen.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Medical Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Access and manage all your clinical documentation in one secure environment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search records....',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildRecordCard(context, 'Blood Test Result', 'PDF • 12 Oct 2023', Icons.picture_as_pdf),
                  _buildRecordCard(context, 'Chest X-Ray', 'Image • 05 Oct 2023', Icons.image_outlined),
                  _buildRecordCard(context, 'Vaccination Card', 'PDF • 22 Sep 2023', Icons.picture_as_pdf),
                  _buildRecordCard(context, 'Cardiology Report', 'PDF • 15 Aug 2023', Icons.description),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadRecordScreen()));
        },
        backgroundColor: const Color(0xFF0056B3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Upload Record', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, String title, String date, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE8F1F9), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF1A394A)),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A394A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFE8F1F9), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.download_outlined, color: Color(0xFF1A394A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}