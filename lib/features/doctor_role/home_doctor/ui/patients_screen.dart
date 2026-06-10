import 'package:flutter/material.dart';
import 'patient_overview_screen.dart';

class PatientsScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const PatientsScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text("Patients", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                      onPressed: () => onNavigate(0),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("Patients", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text("Active List", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text("You have 24 appointments scheduled this week.", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 25),
                    _buildPatientCard(onNavigate: onNavigate, name: "Akram Emad", info: "28, Male", condition: "Annual Checkup", color: Colors.blue),
                    _buildPatientCard(onNavigate: onNavigate, name: "Omar Reda", info: "45, Male", condition: "Annual Checkup", color: Colors.orange),
                    _buildPatientCard(onNavigate: onNavigate, name: "Ali Amer", info: "32, Male", condition: "Chronic Back Pain", color: Colors.red),
                    _buildPatientCard(onNavigate: onNavigate, name: "David Smith", info: "68, Male", condition: "Hypertension Review", color: Colors.green),
                    _buildPatientCard(onNavigate: onNavigate, name: "Emad Ali", info: "28, Male", condition: "Post-op Follow-up", color: Colors.indigo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPatientCard(
      {required Function(int) onNavigate,
        required String name,
        required String info,
        required String condition,
        required Color color}) {
    return GestureDetector(
      onTap: () => onNavigate(4),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/default_avatar.png')),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(info, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Text(condition, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 16),
          ],
        ),
      ),
    );
  }
}
