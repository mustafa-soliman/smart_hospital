import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/payment_status_popup.dart';

class PatientPaymentScreen extends StatefulWidget {
  final String doctorId;
  final String appointmentDate;
  final String appointmentTime;

  const PatientPaymentScreen({
    super.key,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<PatientPaymentScreen> createState() => _PatientPaymentScreenState();
}

class _PatientPaymentScreenState extends State<PatientPaymentScreen> {
  int selectedMethod = 0;
  bool _isProcessing = false;
  final _supabase = Supabase.instance.client;

  Future<void> _processAppointmentPayment() async {
    setState(() => _isProcessing = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final patientData = await _supabase
          .from('patients')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final actualPatientId = patientData['id'];

      await _supabase.from('appointments').insert({
        'patient_id': actualPatientId,
        'doctor_id': widget.doctorId,
        'appointment_date': widget.appointmentDate,
        'appointment_time': widget.appointmentTime,
        'status': 'pending',
        'type': 'online',
      });

      if (!mounted) return;
      showPaymentStatusDialog(context, true);
    } catch (e) {
      debugPrint("Payment/Booking Error: $e");
      if (mounted) {
        showPaymentStatusDialog(context, false);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STATEMENT TOTAL', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const Text('300.00Eg', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A394A))),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F7).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Includes consultation and lab diagnostics for patient #0429.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A))),
                      TextButton(
                        onPressed: () {},
                        child: const Text('ADD NEW', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildPaymentMethodTile(0, 'assets/images/apple_pay.png', 'Apple Pay', 'Fast and secure'),
                  _buildPaymentMethodTile(1, 'assets/images/visa.png', 'Visa •••• 4242', 'Expires 09/25'),
                  _buildPaymentMethodTile(2, 'assets/images/insurance.png', 'Health Insurance', 'Aetna - Policy #8812'),
                  const SizedBox(height: 25),
                  _buildFeeRow('Service Fee', '00.0'),
                  _buildFeeRow('Hospital Tax', '00.0'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processAppointmentPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A394A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Text('Pay300.00Eg', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(int methodIndex, String imagePath, String title, String subtitle) {
    bool isSelected = selectedMethod == methodIndex;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = methodIndex),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.credit_card, color: Color(0xFF1A394A)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? Colors.blue : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }
}