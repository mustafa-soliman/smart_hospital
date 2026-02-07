import 'package:flutter/material.dart';
// استيراد نافذة الانتظار
import 'package:smart_hospital/screens/waiting_response_popup.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية التي سميتها hospital_bg.png
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text('Patient & Case Details', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 40),
                  _buildLabel('Name'),
                  _buildField('Enter your Name'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel('Age'), _buildField('Enter your Age')])),
                      const SizedBox(width: 20),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel('Gender'), _buildDropdown()])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Medical History'),
                  _buildField('E.g., diabetes, hypertension, heart disease'),
                  const SizedBox(height: 20),
                  _buildLabel('Allergies'),
                  _buildField('Known allergies (if any)'),
                  const SizedBox(height: 20),
                  _buildLabel('Vital Signs'),
                  _buildField('', maxLines: 2),
                  const SizedBox(height: 40),

                  // زر Request الذي يفتح صفحة الانتظار
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WaitingResponsePopup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Request', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))));
  Widget _buildField(String hint, {int maxLines = 1}) => TextField(maxLines: maxLines, decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white.withOpacity(0.8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)));
  Widget _buildDropdown() => Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(15)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: selectedGender, isExpanded: true, items: ['Male', 'Female'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => selectedGender = v!))));
}