import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patient_overview_screen.dart';

class ScheduleDoctorScreen extends StatefulWidget {
  const ScheduleDoctorScreen({super.key});

  @override
  State<ScheduleDoctorScreen> createState() => _ScheduleDoctorScreenState();
}

class _ScheduleDoctorScreenState extends State<ScheduleDoctorScreen> {
  DateTime selectedDate = DateTime.now();
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  List<dynamic> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsForDate(selectedDate);
  }

  Future<void> _fetchAppointmentsForDate(DateTime date) async {
    setState(() => _isLoading = true);
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
          final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

          final data = await _supabase
              .from('appointments')
              .select('*, patients(id, profiles(full_name, avatar_url))')
              .eq('doctor_id', doctorId)
              .eq('appointment_date', formattedDate)
              .order('appointment_time', ascending: true);

          setState(() {
            _appointments = data;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _fetchAppointmentsForDate(date);
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0061C4),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1B3A4B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      _onDateSelected(picked);
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
        automaticallyImplyLeading: false,
        title: const Text(
          "Schedule",
          style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF1F4F7),
              child: IconButton(
                icon: const Icon(Icons.calendar_month, color: Color(0xFF1B3A4B), size: 20),
                onPressed: () => _pickCustomDate(context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  TextButton(
                    onPressed: () => _onDateSelected(DateTime.now()),
                    child: const Text("Today", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 15,
                itemBuilder: (context, index) {
                  final day = selectedDate.add(Duration(days: index - 2));
                  final bool isSelected = day.day == selectedDate.day && day.month == selectedDate.month && day.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () => _onDateSelected(day),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekDayLetter(day.weekday),
                            style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            day.day.toString(),
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Upcoming Appointments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B3A4B)))
                  : _appointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  final patientData = appointment['patients'];
                  final patientProfile = patientData?['profiles'];
                  final String patientName = patientProfile?['full_name'] ?? 'Unknown Patient';
                  final String? avatarUrl = patientProfile?['avatar_url'];
                  final String time = appointment['appointment_time'].toString().substring(0, 5);
                  final String status = appointment['status'] ?? 'pending';
                  final String patientId = patientData?['id'] ?? '';

                  return _buildAppointmentTimelineCard(
                    context,
                    name: patientName,
                    time: time,
                    status: status,
                    avatarUrl: avatarUrl,
                    patientId: patientId,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTimelineCard(
      BuildContext context, {
        required String name,
        required String time,
        required String status,
        required String? avatarUrl,
        required String patientId,
      }) {
    Color statusColor = Colors.orange;
    Color statusBg = const Color(0xFFFFF3E0);
    if (status == 'confirmed') {
      statusColor = Colors.green;
      statusBg = const Color(0xFFE8F5E9);
    }

    return GestureDetector(
      onTap: () {
        if (patientId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientOverviewScreen(patientId: patientId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F4F7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                  child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B3A4B))),
            const Text("Medication Review", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 30),
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 15),
          const Text("No Appointments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month - 1];
  }

  String _getWeekDayLetter(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }
}