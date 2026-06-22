import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patient_overview_screen.dart';

class PatientsScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const PatientsScreen({super.key, required this.onNavigate});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _patientsList = [];

  @override
  void initState() {
    super.initState();
    _fetchMyPatients();
  }

  Future<void> _fetchMyPatients() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final doctorData = await _supabase
            .from('doctors')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        if (doctorData != null) {
          final String doctorId = doctorData['id'];

          final data = await _supabase
              .from('appointments')
              .select('patients(id, blood_type, date_of_birth, gender, profiles(full_name, avatar_url))')
              .eq('doctor_id', doctorId);

          final Map<String, dynamic> uniquePatients = {};
          for (var item in data) {
            if (item['patients'] != null) {
              final patient = item['patients'];
              final patientId = patient['id'];
              uniquePatients[patientId] = patient;
            }
          }

          if (mounted) {
            setState(() {
              _patientsList = uniquePatients.values.toList();
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching patients: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
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
              onPressed: () => widget.onNavigate(0),
            ),
          ),
        ),
        title: const Text("Patients", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Active List", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 4),
                  Text("You have ${_patientsList.length} appointments scheduled this week.", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B3A4B)))
                  : _patientsList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _patientsList.length,
                itemBuilder: (context, index) {
                  final patient = _patientsList[index];
                  final profile = patient['profiles'];
                  final String patientName = profile?['full_name'] ?? 'Unknown Patient';
                  final String bloodType = patient['blood_type'] ?? 'A+';
                  final String gender = patient['gender'] ?? 'Male';
                  final String? avatarUrl = profile?['avatar_url'];

                  int age = 28;
                  if (patient['date_of_birth'] != null) {
                    age = DateTime.now().year - DateTime.parse(patient['date_of_birth'].toString()).year;
                  }

                  return _buildPatientCard(
                    context,
                    name: patientName,
                    info: "$age, $gender",
                    condition: "Annual Checkup",
                    color: const Color(0xFF0061C4),
                    avatarUrl: avatarUrl,
                    patientId: patient['id'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(
      BuildContext context, {
        required String name,
        required String info,
        required String condition,
        required Color color,
        String? avatarUrl,
        required String patientId,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientOverviewScreen(patientId: patientId, onNavigate: widget.onNavigate),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F4F7)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 4),
                  Text(info, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                    child: Text(condition, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text("No Patients Found", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}