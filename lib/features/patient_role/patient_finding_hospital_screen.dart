import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_ambulance_navigation_screen.dart';

class PatientFindingHospitalScreen extends StatefulWidget {
  const PatientFindingHospitalScreen({super.key});

  @override
  State<PatientFindingHospitalScreen> createState() => _PatientFindingHospitalScreenState();
}

class _PatientFindingHospitalScreenState extends State<PatientFindingHospitalScreen> {
  @override
  void initState() {
    super.initState();
    // محاكاة البحث لمدة 3 ثواني ثم الانتقال للخريطة
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PatientAmbulanceNavigationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.red),
            const SizedBox(height: 30),
            const Text('Finding nearest hospital...', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
            const Text('Scanning for open emergency departments...', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A394A), minimumSize: const Size(200, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.phone, color: Colors.white), SizedBox(width: 10), Text('Call Dispatch', style: TextStyle(color: Colors.white))]),
            )
          ],
        ),
      ),
    );
  }
}