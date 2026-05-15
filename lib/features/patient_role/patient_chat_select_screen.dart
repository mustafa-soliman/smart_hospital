import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_chat_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_book_appointment_screen.dart';

class PatientChatSelectScreen extends StatelessWidget {
  const PatientChatSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Select Doctor', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildDoctorCard(context, 'Dr. Hamza Ahmed', 'Cardiologist', '4.9', 'Online', true),
          _buildDoctorCard(context, 'Dr. Ahmed Ali', 'Neurologist', '4.8', 'Away', false),
          const SizedBox(height: 10),
          _buildFeaturedDoctorCard(context),
          const SizedBox(height: 10),
          _buildDoctorCard(context, 'Dr. Ali Eid', 'Dentist', '5.0', 'Online', true),
          _buildDoctorCard(context, 'Dr. Ahmed Gmal', 'Dermatologist', '5.0', '15m ago', false),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, String name, String specialty, String rating, String status, bool isOnline) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PatientChatScreen(doctorName: name))),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('assets/images/default_avatar.png', width: 70, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.chat_bubble_outline, color: Color(0xFF4A90E2)),
                const SizedBox(height: 5),
                Text(status, style: TextStyle(color: isOnline ? Colors.green : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedDoctorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0061C4), borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('MOST BOOKED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                const Text('Dr. Gamal Ahmed', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Cardiologist • 12 years exp.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PatientBookAppointmentScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0061C4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Book Consult', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('assets/images/default_avatar.png', width: 90, height: 110, fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}