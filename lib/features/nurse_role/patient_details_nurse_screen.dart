import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'medication_screen.dart';
import 'patient_history_screen.dart';

class PatientDetailsNurseScreen extends StatefulWidget {
  final String patientName;
  final String roomNumber;
  final String? caseId;

  const PatientDetailsNurseScreen({
    super.key,
    required this.patientName,
    required this.roomNumber,
    this.caseId,
  });

  @override
  State<PatientDetailsNurseScreen> createState() => _PatientDetailsNurseScreenState();
}

class _PatientDetailsNurseScreenState extends State<PatientDetailsNurseScreen> {
  String _currentStatus = 'Stable';
  final _supabase = Supabase.instance.client;
  final TextEditingController _nurseNoteController = TextEditingController();
  bool _isLoadingNotes = true;
  bool _isUpdating = false;
  String _doctorConsultationNotes = 'Patient is responsive and vitals are stable. Scheduled for physical therapy at 2 PM.';

  @override
  void initState() {
    super.initState();
    _fetchDoctorNotes();
  }

  @override
  void dispose() {
    _nurseNoteController.dispose();
    super.dispose();
  }

  Future<void> _fetchDoctorNotes() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final patientData = await _supabase
            .from('patients')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        if (patientData != null) {
          final medicalRecord = await _supabase
              .from('medical_records')
              .select('diagnosis')
              .eq('patient_id', patientData['id'])
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();

          if (medicalRecord != null && medicalRecord['diagnosis'] != null) {
            if (mounted) {
              setState(() {
                _doctorConsultationNotes = medicalRecord['diagnosis'];
              });
            }
          }
        }
      }
      if (mounted) setState(() => _isLoadingNotes = false);
    } catch (e) {
      debugPrint("Error fetching doctor notes for nurse: $e");
      if (mounted) setState(() => _isLoadingNotes = false);
    }
  }

  Future<void> _updateStatusInSupabase(String newStatus) async {
    if (widget.caseId == null) return;
    setState(() => _isUpdating = true);

    try {
      await _supabase
          .from('emergency_cases')
          .update({'status': newStatus.toLowerCase()})
          .eq('id', widget.caseId!);

      if (mounted) {
        setState(() {
          _currentStatus = newStatus;
        });
        _showTopSuccessToast('Status updated successfully');
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _saveNurseNoteLive() async {
    if (_nurseNoteController.text.trim().isEmpty) return;
    setState(() => _isUpdating = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final patientData = await _supabase
            .from('patients')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        if (patientData != null) {
          await _supabase.from('medical_records').insert({
            'patient_id': patientData['id'],
            'diagnosis': _nurseNoteController.text.trim(),
            'treatment': 'Routine Nurse Observation',
          });

          if (mounted) {
            setState(() {
              _doctorConsultationNotes = _nurseNoteController.text.trim();
            });
            _nurseNoteController.clear();
            _showTopSuccessToast('Note saved successfully');
          }
        }
      }
    } catch (e) {
      debugPrint("Error saving nurse note: $e");
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _showTopSuccessToast(String message) {
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
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F8EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: Color(0xFF53C07F), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: const TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            if (message.contains('Note'))
                              const Text('History updated in real-time', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
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

  void _showUpdateStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 16,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 44, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  const Text('Update Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
                  const SizedBox(height: 4),
                  Text('Select the current clinical status for ${widget.patientName}.', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 20),
                  _buildStatusRadioOption('Stable', 'Vitals within normal range', setModalState),
                  _buildStatusRadioOption('Needs Attention', 'Minor fluctuations in vitals', setModalState),
                  _buildStatusRadioOption('Critical', 'Urgent medical intervention needed', setModalState),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateStatusInSupabase(_currentStatus);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF132530), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0),
                    child: const Text('Save State', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _showAddNoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 16,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 44, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Note', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
                      const SizedBox(height: 2),
                      Text('${widget.patientName}   Room ${widget.roomNumber}', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: Color(0xFF007AFF)),
                      SizedBox(width: 4),
                      Text('12 Oct, 10:45 AM', style: TextStyle(fontSize: 12, color: Color(0xFF007AFF), fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextFormField(
                  controller: _nurseNoteController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF0F0F17)),
                  decoration: const InputDecoration(
                    hintText: 'Write note here...',
                    hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveNurseNoteLive();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF132530), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0),
                child: const Text('Save Note', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
  }

  Widget _buildStatusRadioOption(String title, String subtitle, StateSetter setModalState) {
    bool isSelected = _currentStatus == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: RadioListTile<String>(
        value: title,
        groupValue: _currentStatus,
        activeColor: const Color(0xFF007AFF),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F0F17))),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        onChanged: (value) {
          if (value != null) {
            setModalState(() {
              setState(() {
                _currentStatus = value;
              });
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F0F17), size: 16), onPressed: () => Navigator.pop(context)),
          ),
        ),
        title: const Text('Patient Details', style: TextStyle(color: Color(0xFF132530), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Center(child: CircleAvatar(radius: 55, backgroundImage: AssetImage('assets/images/default_avatar.png'))),
                    const SizedBox(height: 16),
                    Center(child: Text(widget.patientName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.meeting_room_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("Room ${widget.roomNumber}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Health Vitals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationScreen(patientName: widget.patientName, roomNumber: widget.roomNumber)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Medication', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildVitalCard('72', 'bpm', 'Heart Rate', Icons.favorite, const Color(0xFFE05858), const Color(0xFFFDEBEB)),
                        const SizedBox(width: 16),
                        _buildVitalCard('98.6', '°F', 'Temperature', Icons.thermostat_rounded, const Color(0xFF007AFF), const Color(0xFFE3F2FD)),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nurse Observations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PatientHistoryScreen(patientName: widget.patientName, roomNumber: widget.roomNumber)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('View History', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isLoadingNotes
                              ? const Center(child: SizedBox(height: 20, width: 24, child: CircularProgressIndicator(color: Color(0xFF007AFF), strokeWidth: 2)))
                              : Text(
                            _doctorConsultationNotes,
                            style: const TextStyle(color: Color(0xFF334155), fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: const Color(0xFF007AFF).withValues(alpha: 0.1),
                                child: const Text('NJ', style: TextStyle(fontSize: 10, color: Color(0xFF007AFF), fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              const Text('Updated 14m ago by Nurse Jane', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showUpdateStatusBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF132530),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Update Status', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _showAddNoteBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F4F7),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Add Note', style: TextStyle(color: Color(0xFF132530), fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(String value, String unit, String title, IconData icon, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
            const SizedBox(height: 18),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))), const SizedBox(width: 4), Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 13))]),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}