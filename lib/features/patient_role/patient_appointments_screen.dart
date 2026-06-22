import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/patient_appointment_details_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_list_screen.dart';
import 'package:smart_hospital/features/patient_role/cancel_appointment_dialog.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchMyAppointments();
  }

  Future<void> _fetchMyAppointments() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final patientData = await _supabase
          .from('patients')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final patientId = patientData['id'];

      final data = await _supabase
          .from('appointments')
          .select('*, doctors(specialization, profiles(full_name, avatar_url))')
          .eq('patient_id', patientId)
          .order('appointment_date', ascending: true);

      List<Map<String, dynamic>> loadedAppointments = [];
      for (var item in data) {
        final doctor = item['doctors'];
        final profile = doctor != null ? doctor['profiles'] : null;

        loadedAppointments.add({
          'id': item['id'],
          'date': item['appointment_date'].toString(),
          'time': item['appointment_time'].toString().substring(0, 5),
          'status': item['status'] ?? 'pending',
          'doc_name': profile != null ? profile['full_name'] ?? 'Dr. Expert' : 'Dr. Expert',
          'specialty': doctor != null ? doctor['specialization'] ?? 'Specialist' : 'Specialist',
          'avatar_url': profile != null ? profile['avatar_url'] : null,
        });
      }

      setState(() {
        _appointments = loadedAppointments;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
            : RefreshIndicator(
          onRefresh: _fetchMyAppointments,
          color: const Color(0xFF1A394A),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'My Appointments',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your clinical sessions and\nhealth consultations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 30),
                _appointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final app = _appointments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildAppointmentCard(
                        context,
                        id: app['id'],
                        docName: app['doc_name'],
                        specialty: app['specialty'],
                        dateStr: app['date'],
                        timeStr: app['time'],
                        status: app['status'],
                        avatarUrl: app['avatar_url'],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                _buildPromoCard(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, {
        required String id,
        required String docName,
        required String specialty,
        required String dateStr,
        required String timeStr,
        required String status,
        required String? avatarUrl,
      }) {
    bool isConfirmed = status.toLowerCase() == 'confirmed';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(avatarUrl, width: 60, height: 60, fit: BoxFit.cover)
                    : const Image(image: AssetImage('assets/images/default_avatar.png'), width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(docName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A394A))),
                    const SizedBox(height: 4),
                    Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isConfirmed ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isConfirmed ? 'Confirmed' : 'Pending',
                  style: TextStyle(
                    color: isConfirmed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(dateStr, style: const TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.w500)),
              const SizedBox(width: 20),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(timeStr, style: const TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => showCancelAppointmentDialog(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1A394A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientAppointmentDetailsScreen(
                          doctorName: docName,
                          specialization: specialty,
                          appointmentDate: dateStr,
                          appointmentTime: timeStr,
                          status: status,
                          avatarUrl: avatarUrl,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A394A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0061C4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Health Checkup', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Don't forget your annual full-\nbody screening. Book now and\nget 20% off.",
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDoctorListScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0061C4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.calendar_month_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 15),
            Text("No appointments scheduled yet.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}