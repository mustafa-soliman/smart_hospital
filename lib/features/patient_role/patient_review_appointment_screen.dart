import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_payment_screen.dart';

class PatientReviewAppointmentScreen extends StatelessWidget {
  final String doctorId;
  final String appointmentDate;
  final String appointmentTime;

  const PatientReviewAppointmentScreen({
    super.key,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Review Appointment', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Confirm your booking details below.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            _buildDoctorSummaryCard(),
            const SizedBox(height: 30),
            const Text('BOOKING DETAILS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),
            _buildDetailTile(Icons.videocam_outlined, 'CONSULTATION TYPE', 'Video Conference', true),
            _buildDetailTile(Icons.calendar_today_outlined, 'DATE', appointmentDate, false),
            _buildDetailTile(Icons.access_time, 'TIME', appointmentTime, false),
            const SizedBox(height: 30),
            _buildSecurePaymentInfo(),
            const SizedBox(height: 40),
            _buildConfirmButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: const Image(
              image: AssetImage('assets/images/default_avatar.png'),
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. Hamza Ahmed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A394A))),
                SizedBox(height: 4),
                Text('Senior Cardiologist', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value, bool hasArrow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F4F7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A394A), size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Spacer(),
          if (hasArrow) const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSecurePaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF78858F), borderRadius: BorderRadius.circular(16)),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 15),
          Expanded(child: Text('Your data is encrypted using clinical-grade protocols. You can cancel free of charge up to 24 hours before.', style: TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientPaymentScreen(
              doctorId: doctorId,
              appointmentDate: appointmentDate,
              appointmentTime: appointmentTime,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A394A),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: const Text('Confirm & Pay 300.00Eg', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}