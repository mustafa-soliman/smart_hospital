import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_appointment_details_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_details_screen.dart';
import 'package:smart_hospital/features/patient_role/cancel_appointment_dialog.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_list_screen.dart'; // 👈 1. استيراد صفحة قائمة الدكاترة الصحيحة هنا

class PatientAppointmentsScreen extends StatelessWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'My Appointments',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your clinical sessions and\nhealth consultations.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),
              _buildAppointmentCard(
                context,
                doctorName: 'Dr. Ali Eid',
                specialty: 'DENTIST',
                status: 'Confirmed',
                statusColor: Colors.green,
                dateTime: 'Oct 24, 2023 • 10:30 AM',
              ),
              const SizedBox(height: 20),
              _buildAppointmentCard(
                context,
                doctorName: 'Dr. Ali Eid',
                specialty: 'DENTIST',
                status: 'Pending',
                statusColor: Colors.orange,
                dateTime: 'Oct 24, 2023 • 10:30 AM',
              ),
              const SizedBox(height: 30),
              _buildHealthCheckupBanner(context), // مررنا الـ context هنا للبانر
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, {
        required String doctorName,
        required String specialty,
        required String status,
        required Color statusColor,
        required String dateTime,
      }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/default_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialty,
                      style: const TextStyle(
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1A394A),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Color(0xFF4A90E2)),
                const SizedBox(width: 10),
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: Color(0xFF1A394A),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => showCancelAppointmentDialog(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientAppointmentDetailsScreen(),
                      ),
                    );
                  },
                  child: const Text('Reschedule', style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCheckupBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0061C4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Health Checkup', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            'Don\'t forget your annual full-\nbody screening. Book now and\nget 20% off.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // 👈 2. التعديل هنا: الانتقال لشاشة قائمة الدكاترة ليقوم المريض بالاختيار أولاً
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientDoctorListScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0061C4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}