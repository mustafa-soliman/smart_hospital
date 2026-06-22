import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patient_details_nurse_screen.dart';
import 'total_patients_screen.dart';

class HomeNurseScreen extends StatefulWidget {
  final Map<String, dynamic>? nurseProfile;

  const HomeNurseScreen({super.key, this.nurseProfile});

  @override
  State<HomeNurseScreen> createState() => _HomeNurseScreenState();
}

class _HomeNurseScreenState extends State<HomeNurseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _todayPatientsQueue = [];
  int _totalPatientsCount = 0;
  int _todayAppointmentsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchNurseDashboardData();
  }

  Future<void> _fetchNurseDashboardData() async {
    try {
      final now = DateTime.now();
      final String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final patientsRes = await _supabase
          .from('patients')
          .select('id');

      final appointmentsData = await _supabase
          .from('appointments')
          .select('*, patients(id, profiles(full_name, avatar_url))')
          .eq('appointment_date', todayStr)
          .order('appointment_time', ascending: true);

      if (mounted) {
        setState(() {
          _totalPatientsCount = patientsRes.length;
          _todayAppointmentsCount = appointmentsData.length;
          _todayPatientsQueue = appointmentsData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading nurse dashboard: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String nurseName = widget.nurseProfile?['full_name'] ?? 'Nurse';
    final String? avatarUrl = widget.nurseProfile?['avatar_url'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF007AFF)))
            : SingleChildScrollView(
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
                          const TextSpan(text: "Good Morning, ", style: TextStyle(fontWeight: FontWeight.w400)),
                          TextSpan(text: nurseName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TotalPatientsScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
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
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF007AFF), size: 28),
                          const SizedBox(height: 12),
                          const Text("Today's\nAppointments", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("$_todayAppointmentsCount", style: const TextStyle(color: Color(0xFF007AFF), fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search patient or room...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Today's Scheduled Patients",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 15),
              _todayPatientsQueue.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _todayPatientsQueue.length,
                itemBuilder: (context, index) {
                  final appointment = _todayPatientsQueue[index];
                  final patientProfile = appointment['patients']?['profiles'];
                  final String patientName = patientProfile?['full_name'] ?? 'Unknown Patient';
                  final String? patientAvatar = patientProfile?['avatar_url'];
                  final String time = appointment['appointment_time'].toString().substring(0, 5);
                  final String status = appointment['status'] ?? 'pending';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPatientScheduleCard(
                      context,
                      name: patientName,
                      time: time,
                      status: status,
                      avatarUrl: patientAvatar,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientScheduleCard(
      BuildContext context, {
        required String name,
        required String time,
        required String status,
        required String? avatarUrl,
      }) {
    bool isConfirmed = status.toLowerCase() == 'confirmed';

    Color statusColor = const Color(0xFFC96A1F);
    Color statusBg = const Color(0xFFFEF5E6);
    String statusText = 'Waiting';

    if (isConfirmed) {
      statusColor = Colors.green;
      statusBg = const Color(0xFFE8F8EE);
      statusText = 'Confirmed';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailsNurseScreen(
              patientName: name,
              roomNumber: "302",
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Color(0xFF007AFF)),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Medication & Vitals Check",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFF1F5F9),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text(
          "No Patients Scheduled for Today.",
          style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}