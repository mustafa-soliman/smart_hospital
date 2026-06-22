import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientOverviewScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  final String? patientId;

  const PatientOverviewScreen({super.key, this.onNavigate, this.patientId});

  @override
  State<PatientOverviewScreen> createState() => _PatientOverviewScreenState();
}

class _PatientOverviewScreenState extends State<PatientOverviewScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _patientData;
  Map<String, dynamic>? _appointmentDetails;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatientDetails() async {
    if (widget.patientId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final patientInfo = await _supabase
          .from('patients')
          .select('*, profiles(full_name, avatar_url)')
          .eq('id', widget.patientId!)
          .maybeSingle();

      final appointmentInfo = await _supabase
          .from('appointments')
          .select('appointment_date, appointment_time')
          .eq('patient_id', widget.patientId!)
          .order('appointment_date', ascending: false)
          .limit(1)
          .maybeSingle();

      final medicalRecord = await _supabase
          .from('medical_records')
          .select('diagnosis')
          .eq('patient_id', widget.patientId!)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      setState(() {
        _patientData = patientInfo;
        _appointmentDetails = appointmentInfo;
        if (medicalRecord != null) {
          _notesController.text = medicalRecord['diagnosis'] ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching details: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConsultationNotes() async {
    if (widget.patientId == null || _notesController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final user = _supabase.auth.currentUser;
      final doctorData = await _supabase
          .from('doctors')
          .select('id')
          .eq('user_id', user!.id)
          .maybeSingle();

      if (doctorData != null) {
        await _supabase.from('medical_records').insert({
          'patient_id': widget.patientId,
          'doctor_id': doctorData['id'],
          'diagnosis': _notesController.text.trim(),
          'treatment': 'Prescribed during session',
        });

        if (!mounted) return;
        _showSuccessNotification();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving notes: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSuccessNotification() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.check, color: Colors.green, size: 32)),
              const SizedBox(height: 20),
              const Text("Note saved successfully", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3A4B))),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.onNavigate != null) widget.onNavigate!(2);
                  },
                  child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _patientData?['profiles'];
    final String patientName = profile?['full_name'] ?? 'Loading Patient...';
    final String gender = _patientData?['gender'] ?? 'Male';
    final String? avatarUrl = profile?['avatar_url'];
    final String dateStr = _appointmentDetails?['appointment_date'] ?? 'Tue, 17 Oct 2023';
    final String timeStr = _appointmentDetails?['appointment_time'] != null ? _appointmentDetails!['appointment_time'].toString().substring(0, 5) : '09:30 AM';

    int age = 28;
    if (_patientData?['date_of_birth'] != null) {
      age = DateTime.now().year - DateTime.parse(_patientData!['date_of_birth'].toString()).year;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
              onPressed: () {
                if (widget.onNavigate != null) {
                  widget.onNavigate!(2);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        title: const Text("Patient Overview", style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B3A4B)))
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F4F7)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1B3A4B))),
                          const SizedBox(height: 4),
                          Text("Age: $age  •  $gender", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                            child: const Text("Annual Wellness Checkup", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text("SCHEDULE DETAILS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildScheduleInfoCard(Icons.calendar_today, "DATE", dateStr)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildScheduleInfoCard(Icons.access_time, "TIME", timeStr)),
                ],
              ),
              const SizedBox(height: 30),
              const Text("CONSULTATION NOTES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F4F7)),
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: "Write patient diagnosis, symptoms, and prescribed treatment here...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveConsultationNotes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A4B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Consultation Notes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFBFBFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F4F7))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.blue),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B3A4B))),
        ],
      ),
    );
  }
}