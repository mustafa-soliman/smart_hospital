import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_payment_screen.dart';

class PatientReviewAppointmentScreen extends StatelessWidget {
  const PatientReviewAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
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
            _buildDetailTile(Icons.account_balance_wallet_outlined, 'CONSULTATION FEE', '300.00Eg', false),
            _buildDetailTile(Icons.person_outline, 'PATIENT NAME', 'Ahmed', false),
            const SizedBox(height: 30),
            _buildSecurePaymentInfo(),
            const SizedBox(height: 40),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('assets/images/default_avatar.png', width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                    child: const Text('VERIFIED EXPERT', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  const Text('Dr. Hamza Ahmed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text('Senior Cardiologist', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDateTimeInfo(Icons.calendar_today, 'DATE', 'Oct 24, 2025'),
              _buildDateTimeInfo(Icons.access_time, 'TIME', '10:30 AM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfo(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [Icon(icon, color: Colors.blue, size: 18), const SizedBox(width: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, bool hasArrow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.blue)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))],
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
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientPaymentScreen())),
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A394A), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: const Text('Confirm & Pay 300.00Eg', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}