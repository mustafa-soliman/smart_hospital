import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/patient_book_appointment_screen.dart';

class PatientDoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const PatientDoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<PatientDoctorDetailsScreen> createState() => _PatientDoctorDetailsScreenState();
}

class _PatientDoctorDetailsScreenState extends State<PatientDoctorDetailsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _doctorData;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final data = await _supabase
          .from('doctors')
          .select('id, specialization, consultation_fee, rating, years_experience, total_patients, total_reviews, bio, profiles(full_name, avatar_url)')
          .eq('id', widget.doctorId)
          .single();

      setState(() {
        _doctorData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching doctor details: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1A394A))),
      );
    }

    if (_doctorData == null) {
      return const Scaffold(
        body: Center(child: Text('Doctor profiles could not be loaded.')),
      );
    }

    final profile = _doctorData!['profiles'] as Map<String, dynamic>?;
    final String name = profile?['full_name'] ?? 'Doctor';
    final String specialty = _doctorData!['specialization'] ?? 'Specialist';
    final String? avatar = profile?['avatar_url'];
    final String bio = _doctorData!['bio'] ?? 'No bio available for this doctor yet.';
    final String rating = _doctorData!['rating']?.toString() ?? '5.0';
    final String experience = _doctorData!['years_experience']?.toString() ?? '0';
    final String patients = _doctorData!['total_patients']?.toString() ?? '0';
    final String reviews = _doctorData!['total_reviews']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Doctor',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: avatar != null && avatar.isNotEmpty
                        ? Image.network(avatar, width: double.infinity, height: 300, fit: BoxFit.cover)
                        : const Image(image: AssetImage('assets/images/default_avatar.png'), width: double.infinity, height: 300, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: const Icon(Icons.favorite_border, color: Color(0xFF4A90E2)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          specialty,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '$rating ($reviews reviews)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(Icons.people, '$patients+', 'Patients'),
                  _buildStatItem(Icons.assignment_turned_in, '$experience+', 'Years'),
                  _buildStatItem(Icons.star, rating, 'Rating'),
                  _buildStatItem(Icons.chat_bubble, '$reviews+', 'Reviews'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'About Me',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                bio,
                style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientBookAppointmentScreen(doctorId: widget.doctorId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A394A),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFF1F4F7),
          child: Icon(icon, color: const Color(0xFF1A394A)),
        ),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}