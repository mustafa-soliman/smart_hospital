import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/screens/waiting_response_popup.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final _supabase = Supabase.instance.client;
  String selectedGender = 'Male';
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _vitalsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _historyController.dispose();
    _allergiesController.dispose();
    _vitalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'Patient & Case Details',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildLabel('Name'),
                        _buildField('Enter your Name', _nameController),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Age'),
                                  _buildField('Enter your Age', _ageController, keyboardType: TextInputType.number),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Gender'),
                                  _buildDropdown(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Medical History'),
                        _buildField('E.g., diabetes, hypertension, heart disease', _historyController),
                        const SizedBox(height: 20),
                        _buildLabel('Allergies'),
                        _buildField('Known allergies (if any)', _allergiesController),
                        const SizedBox(height: 20),
                        _buildLabel('Vital Signs'),
                        _buildField('', _vitalsController, maxLines: 2),
                        const Expanded(child: SizedBox(height: 40)),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              if (_nameController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter patient name')),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              try {
                                final response = await _supabase.from('emergency_cases').insert({
                                  'patient_name': _nameController.text.trim(),
                                  'patient_age': int.tryParse(_ageController.text.trim()) ?? 0,
                                  'patient_gender': selectedGender.toLowerCase(),
                                  'condition_description': _historyController.text.trim(),
                                  'allergies': _allergiesController.text.trim(),
                                  'vital_signs': _vitalsController.text.trim(),
                                  'status': 'waiting',
                                }).select().single();

                                final String newCaseId = response['id'].toString();

                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WaitingResponsePopup(caseId: newCaseId),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error sending request: $e')),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B3A4B),
                              minimumSize: const Size(double.infinity, 60),
                              shape: const StadiumBorder(),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                                : const Text(
                              'Request',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender,
          isExpanded: true,
          items: ['Male', 'Female'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) {
            if (v != null) setState(() => selectedGender = v);
          },
        ),
      ),
    );
  }
}