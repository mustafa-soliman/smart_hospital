import 'package:flutter/material.dart';
import 'patient_overview_screen.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النص الرمادي العلوي
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
                      onPressed: () => Navigator.pop(context),
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

                    _buildPatientCard(context, name: "Akram Emad", info: "28, Male", condition: "Annual Checkup", color: Colors.blue),
                    _buildPatientCard(context, name: "Omar Reda", info: "45, Male", condition: "Annual Checkup", color: Colors.orange),
                    _buildPatientCard(context, name: "Ali Amer", info: "32, Male", condition: "Chronic Back Pain", color: Colors.red),
                    _buildPatientCard(context, name: "David Smith", info: "68, Male", condition: "Hypertension Review", color: Colors.green),
                    _buildPatientCard(context, name: "Emad Ali", info: "28, Male", condition: "Post-op Follow-up", color: Colors.indigo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(2),
    );
  }

  Widget _buildPatientCard(BuildContext context, {required String name, required String info, required String condition, required Color color}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientOverviewScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
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
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
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

  Widget _buildBottomNav(int activeIndex) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF1B3A4B), borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home_outlined, color: activeIndex == 0 ? Colors.white : Colors.grey),
          Icon(Icons.calendar_month_outlined, color: activeIndex == 1 ? Colors.white : Colors.grey),
          Icon(Icons.people, color: activeIndex == 2 ? Colors.white : Colors.grey),
          Icon(Icons.settings_outlined, color: activeIndex == 3 ? Colors.white : Colors.grey),
        ],
      ),
    );
  }
}