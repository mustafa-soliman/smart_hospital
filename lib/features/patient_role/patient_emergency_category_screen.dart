import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_finding_hospital_screen.dart';

class PatientEmergencyCategoryScreen extends StatelessWidget {
  const PatientEmergencyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Emergency', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please provide a quick category for faster response.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildCategoryItem(Icons.medical_services_outlined, 'Accident'),
                _buildCategoryItem(Icons.favorite_outline, 'Heart Problem'),
                _buildCategoryItem(Icons.air, 'Breathing Issue'),
                _buildCategoryItem(Icons.more_horiz, 'Other'),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Live Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildLocationCard(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientFindingHospitalScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A394A), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.sensors, color: Colors.white), SizedBox(width: 10), Text('Request Help', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F4F7), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 35),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        children: [
          Icon(Icons.location_on, color: Color(0xFF4A90E2)),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CURRENT ADDRESS', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 10, fontWeight: FontWeight.bold)), Text('El-Nasr Road, Nasr City, Cairo, Egypt', style: TextStyle(fontWeight: FontWeight.bold))])),
        ],
      ),
    );
  }
}