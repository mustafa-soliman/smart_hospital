import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicationScreen extends StatefulWidget {
  final String patientName;
  final String roomNumber;

  const MedicationScreen({
    super.key,
    required this.patientName,
    required this.roomNumber,
  });

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final _medNameController = TextEditingController();
  final _supabase = Supabase.instance.client;
  String _selectedDosage = '5mg';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  bool _isLoading = true;
  String? _patientId;
  List<dynamic> _medications = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientAndMedications();
  }

  @override
  void dispose() {
    _medNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatientAndMedications() async {
    try {
      final profileRes = await _supabase
          .from('profiles')
          .select('id')
          .eq('full_name', widget.patientName)
          .maybeSingle();

      if (profileRes != null) {
        final patientData = await _supabase
            .from('patients')
            .select('id')
            .eq('user_id', profileRes['id'])
            .maybeSingle();

        if (patientData != null) {
          _patientId = patientData['id'];
          await _loadMedications();
        }
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Error initializing medication screen: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMedications() async {
    if (_patientId == null) return;
    try {
      final data = await _supabase
          .from('medications')
          .select('*')
          .eq('patient_id', _patientId!)
          .order('created_at', ascending: true);

      if (mounted) {
        setState(() {
          _medications = data;
        });
      }
    } catch (e) {
      debugPrint("Error loading medications: $e");
    }
  }

  Future<void> _updateMedicationStatus(String medId, String newStatus, String newSchedule) async {
    try {
      await _supabase
          .from('medications')
          .update({
        'status': newStatus,
        'schedule': newSchedule,
      })
          .eq('id', medId);

      if (mounted) {
        _showStatusToast('Status updated to $newStatus successfully');
        await _loadMedications();
      }
    } catch (e) {
      debugPrint("Error updating medication status: $e");
    }
  }

  Future<void> _addNewMedicationLive() async {
    if (_patientId == null || _medNameController.text.trim().isEmpty) return;
    try {
      final String timeStr = _selectedTime.format(context);

      await _supabase.from('medications').insert({
        'patient_id': _patientId!,
        'name': _medNameController.text.trim(),
        'details': '$_selectedDosage • Oral Tablet',
        'status': 'DUE',
        'schedule': 'Next Dose: $timeStr',
      });

      _medNameController.clear();
      if (mounted) {
        _showStatusToast('Medication added to database successfully');
        await _loadMedications();
      }
    } catch (e) {
      debugPrint("Error adding medication to DB: $e");
    }
  }

  void _showStatusToast(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });
        return Stack(
          children: [
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFE8F8EE), shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, color: Color(0xFF53C07F), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message, style: const TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 14)),
                            const Text('History updated in real-time', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, StateSetter setPopupState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setPopupState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showAddMedicationPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setPopupState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quick Add Medication',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter details for the next dose',
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'MEDICATION NAME',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0061C4)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextFormField(
                      controller: _medNameController,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF0F0F17)),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Insulin',
                        hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DOSAGE',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0061C4)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedDosage,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                                  items: ['5mg', '10mg', '500mg'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val, style: const TextStyle(fontSize: 15, color: Color(0xFF0F0F17))),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setPopupState(() => _selectedDosage = value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TIME',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0061C4)),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectTime(context, setPopupState),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_filled, color: Color(0xFF0061C4), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedTime.format(context),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F0F17)),
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
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addNewMedicationLive();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0061C4),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusTextColor(String status) {
    if (status == 'DUE') return const Color(0xFF0061C4);
    if (status == 'GIVEN') return const Color(0xFF2E7D32);
    return const Color(0xFF475569);
  }

  Color _getStatusContainerBg(String status) {
    if (status == 'DUE') return const Color(0xFFE3F2FD);
    if (status == 'GIVEN') return const Color(0xFFE8F5E9);
    return const Color(0xFFE2E8F0);
  }

  IconData _getMedicationIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('para') || lowerName.contains('pill')) return Icons.local_hospital_rounded;
    if (lowerName.contains('amio') || lowerName.contains('inject')) return Icons.vaccines_rounded;
    return Icons.medication_liquid_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text('Medication', style: TextStyle(color: Color(0xFF132530), fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationPopup,
        backgroundColor: const Color(0xFF0061C4),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF0061C4)))
            : Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFF1F4F7)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Image(
                      image: AssetImage('assets/images/default_avatar.png'),
                      width: 60,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patientName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF132530))),
                        const SizedBox(height: 4),
                        Text('Room ${widget.roomNumber} • ID: #8829-X', style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(10)), child: const Text('STABLE', style: TextStyle(color: Color(0xFF0061C4), fontWeight: FontWeight.bold, fontSize: 10))),
                            const SizedBox(width: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFFFEFE6), borderRadius: BorderRadius.circular(10)), child: const Text('POST-OP DAY 2', style: TextStyle(color: Color(0xFFC96A1F), fontWeight: FontWeight.bold, fontSize: 10))),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _medications.isEmpty
                  ? const Center(child: Text("No medications assigned yet.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  final med = _medications[index];
                  final String medId = med['id'];
                  final String status = med['status'];
                  final String name = med['name'];
                  final bool isDue = status == 'DUE';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFF1F4F7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDue ? const Color(0xFFE3F2FD) : const Color(0xFFF1F4F7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(_getMedicationIcon(name), color: isDue ? const Color(0xFF0061C4) : const Color(0xFF94A3B8), size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDue ? const Color(0xFF132530) : Colors.black45)),
                                  const SizedBox(height: 4),
                                  Text(med['details'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusContainerBg(status),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(color: _getStatusTextColor(status), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(isDue ? Icons.access_time : Icons.check_circle_outline, color: isDue ? const Color(0xFF0061C4) : Colors.grey, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                med['schedule'] ?? '',
                                style: TextStyle(
                                  color: status == 'GIVEN' ? const Color(0xFF2E7D32) : (status == 'SKIPPED' ? Colors.grey : const Color(0xFF132530)),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isDue) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _updateMedicationStatus(medId, 'GIVEN', 'Administered just now'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0061C4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                    minimumSize: const Size(0, 48),
                                  ),
                                  child: const Text('Mark as Given', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _updateMedicationStatus(medId, 'SKIPPED', 'Skipped by nurse observation'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF1F4F7),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                    minimumSize: const Size(0, 48),
                                  ),
                                  child: const Text('Skip', style: TextStyle(color: Color(0xFF132530), fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}