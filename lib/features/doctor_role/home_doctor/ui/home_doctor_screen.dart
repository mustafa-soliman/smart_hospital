import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDoctorScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final Map<String, dynamic>? doctorProfile;

  const HomeDoctorScreen({super.key, required this.onNavigate, this.doctorProfile});

  @override
  State<HomeDoctorScreen> createState() => _HomeDoctorScreenState();
}

class _HomeDoctorScreenState extends State<HomeDoctorScreen> {
  final _supabase = Supabase.instance.client;
  bool _isQueueLoading = true;
  List<dynamic> _upcomingQueue = [];
  int _totalPatientsCount = 0;
  int _todayAppointmentsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDashboardData();
  }

  Future<void> _fetchDoctorDashboardData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final doctorData = await _supabase
          .from('doctors')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (doctorData != null) {
        final String doctorId = doctorData['id'];
        final now = DateTime.now();
        final String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        final appointmentsData = await _supabase
            .from('appointments')
            .select('*, patients(id, profiles(full_name, avatar_url))')
            .eq('doctor_id', doctorId)
            .eq('appointment_date', todayStr)
            .order('appointment_time', ascending: true);

        final allAppointmentsRes = await _supabase
            .from('appointments')
            .select('id')
            .eq('doctor_id', doctorId);

        if (mounted) {
          setState(() {
            _upcomingQueue = appointmentsData;
            _todayAppointmentsCount = appointmentsData.length;
            _totalPatientsCount = allAppointmentsRes.length;
            _isQueueLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
      if (mounted) setState(() => _isQueueLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String doctorName = widget.doctorProfile?['full_name'] ?? 'Doctor';
    final String? avatarUrl = widget.doctorProfile?['avatar_url'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                        children: [
                          const TextSpan(text: "Good Morning, ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: doctorName, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0073F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.people, color: Colors.white, size: 28),
                          const SizedBox(height: 12),
                          const Text("Total Patients", style: TextStyle(color: Color(0xFFFBFBFC), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("$_totalPatientsCount", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF0073F7), size: 28),
                          const SizedBox(height: 12),
                          const Text("Today's\nAppointments", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("$_todayAppointmentsCount", style: const TextStyle(color: Color(0xFF0073F7), fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212529))),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onNavigate(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                        decoration: BoxDecoration(color: const Color(0xFFE5EDFF), borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, color: Color(0xFF1B3A4B), size: 22),
                            SizedBox(width: 10),
                            Text("View\nSchedule", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onNavigate(3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, color: Color(0xFF0073F7), size: 22),
                            SizedBox(width: 10),
                            Text("Messages", style: TextStyle(color: Color(0xFF0073F7), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Upcoming Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212529))),
                      Text("Next ${_upcomingQueue.length} patients in queue", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => widget.onNavigate(1),
                    child: const Text("View All", style: TextStyle(color: Color(0xFF0073F7), fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _isQueueLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF0073F7)))
                  : _upcomingQueue.isEmpty
                  ? _buildEmptyQueueState()
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _upcomingQueue.length > 3 ? 3 : _upcomingQueue.length,
                itemBuilder: (context, index) {
                  final appointment = _upcomingQueue[index];
                  final patientProfile = appointment['patients']?['profiles'];
                  final String patientName = patientProfile?['full_name'] ?? 'Unknown Patient';
                  final String? patientAvatar = patientProfile?['avatar_url'];
                  final String time = appointment['appointment_time'].toString().substring(0, 5);
                  final String status = appointment['status'] ?? 'pending';

                  return _buildQueueItem(patientName, time, status, patientAvatar);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueueItem(String name, String time, String status, String? avatarUrl) {
    bool isConfirmed = status.toLowerCase() == 'confirmed';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF212529))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isConfirmed ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isConfirmed ? 'Confirmed' : 'Waiting',
              style: TextStyle(color: isConfirmed ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQueueState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text("No patients scheduled for today.", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
      ),
    );
  }
}