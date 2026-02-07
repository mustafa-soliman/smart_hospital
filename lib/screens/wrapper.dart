import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/doctor_home_screen.dart';
import 'package:smart_hospital/screens/patient_home_screen.dart';

class AppWrapper extends StatelessWidget {
  // في المستقبل، هذه القيمة ستأتي من Firebase Auth و Firestore
  final String userRole; // "doctor" أو "patient"

  const AppWrapper({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    // بناءً على الرتبة، نفتح الصفحة المناسبة
    if (userRole == "doctor") {
      return const DoctorHomeScreen(
        doctorName: "Mustafa Soliman",
        doctorImage: "assets/images/doctor_avatar.png",
        specialty: "Surgeon",
      );
    } else {
      return const PatientHomeScreen();
    }
  }
}