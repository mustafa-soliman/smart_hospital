import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/payment_status_popup.dart';
class PatientPaymentScreen extends StatefulWidget {
  const PatientPaymentScreen({super.key});

  @override
  State<PatientPaymentScreen> createState() => _PatientPaymentScreenState();
}

class _PatientPaymentScreenState extends State<PatientPaymentScreen> {
  int selectedMethod = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('STATEMENT TOTAL', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const Text('300.00Eg', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A394A))),
            const SizedBox(height: 20),
            _buildInfoBanner(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('ADD NEW')),
              ],
            ),
            const SizedBox(height: 15),
            _buildPaymentTile(0, 'Apple Pay', 'Fast and secure', Icons.apple),
            _buildPaymentTile(1, 'Visa •••• 4242', 'Expires 09/25', Icons.credit_card),
            _buildPaymentTile(2, 'Health Insurance', 'Aetna - Policy #8812', Icons.health_and_safety_outlined),

            const SizedBox(height: 30),
            _buildFeeRow('Service Fee', '00.0'),
            _buildFeeRow('Hospital Tax', '00.0'),
            const SizedBox(height: 25),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.blue, size: 20),
          SizedBox(width: 10),
          Expanded(child: Text('Includes consultation and lab diagnostics for patient #0429.', style: TextStyle(color: Colors.blue, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(int index, String title, String subtitle, IconData icon) {
    bool isSelected = selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.2), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? Colors.blue : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _buildPayButton() {
    return ElevatedButton(
      onPressed: () => showPaymentStatusDialog(context, true),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A394A),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text('Pay 300.00Eg', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}