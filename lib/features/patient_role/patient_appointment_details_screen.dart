import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/cancel_appointment_dialog.dart';

class PatientAppointmentDetailsScreen extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final String? avatarUrl;

  const PatientAppointmentDetailsScreen({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isConfirmed = status.toLowerCase() == 'confirmed';
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorCard(),
            const SizedBox(height: 30),
            const Text(
              'APPOINTMENT INFORMATION',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today_outlined, 'Date', appointmentDate),
                  const Divider(height: 30, thickness: 0.5),
                  _buildInfoRow(Icons.access_time, 'Time', appointmentTime),
                  const Divider(height: 30, thickness: 0.5),
                  _buildInfoRow(
                    Icons.check_circle_outline,
                    'Status',
                    status.toUpperCase(),
                    textColor: isConfirmed ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildNotesCard(),
            const SizedBox(height: 40),
            if (isConfirmed)
              ElevatedButton(
                onPressed: () => showCancelAppointmentDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEAEA),
                  foregroundColor: const Color(0xFFC62828),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  'Cancel Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(avatarUrl!, width: 70, height: 70, fit: BoxFit.cover)
                : const Image(image: AssetImage('assets/images/default_avatar.png'), width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A394A)),
                ),
                const SizedBox(height: 4),
                Text(
                  specialization,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? textColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF007BFF), size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor ?? const Color(0xFF1A394A),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Clinical Notes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A394A), fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Please bring your latest electronic medical report and arrive 15 minutes before the scheduled block time.',
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}