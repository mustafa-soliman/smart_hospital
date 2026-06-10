import 'package:flutter/material.dart';
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/home_doctor_screen.dart';
import 'package:smart_hospital/features/patient_role/home_patient_screen.dart';
import 'package:smart_hospital/features/nurse_role/home_nurse_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userRole;
  final Function(int)? onNavigate;

  const HomeScreen({
    super.key,
    required this.userRole,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case 'Doctor':
        return HomeDoctorScreen(
          onNavigate: onNavigate ?? (index) {},
        );

      case 'Patient':
        return const PatientHomeScreen();

      case 'Nurse':
        return const HomeNurseScreen();

      default:
        return const PatientHomeScreen();
    }
  }
}
