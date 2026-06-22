import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/patient_chat_screen.dart';

class PatientChatSelectScreen extends StatefulWidget {
  const PatientChatSelectScreen({super.key});

  @override
  State<PatientChatSelectScreen> createState() => _PatientChatSelectScreenState();
}

class _PatientChatSelectScreenState extends State<PatientChatSelectScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _doctorsList = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorsForChat();
  }

  Future<void> _fetchDoctorsForChat() async {
    try {
      final data = await _supabase
          .from('doctors')
          .select('id, specialization, rating, status, profiles(full_name, avatar_url)');

      List<Map<String, dynamic>> loadedDoctors = [];
      for (var doc in data) {
        final profile = doc['profiles'] as Map<String, dynamic>?;
        loadedDoctors.add({
          'id': doc['id'],
          'name': profile != null ? profile['full_name'] ?? 'Dr. Expert' : 'Dr. Expert',
          'specialty': doc['specialization'] ?? 'General Practitioner',
          'rating': double.tryParse(doc['rating']?.toString() ?? '5.0') ?? 5.0,
          'status': doc['status'] ?? 'active',
          'avatar_url': profile != null ? profile['avatar_url'] : null,
        });
      }

      setState(() {
        _doctorsList = loadedDoctors;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching chat doctors: $e");
      setState(() => _isLoading = false);
    }
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
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Select Doctor',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
          : Column(
        children: [
          const SizedBox(height: 15),
          _buildSearchBar(),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Experts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                ),
                Text(
                  '${_doctorsList.length} Found',
                  style: const TextStyle(color: Color(0xFF0061C4), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: _doctorsList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: _doctorsList.length,
              itemBuilder: (context, index) {
                final doctor = _doctorsList[index];

                if (index == 2) {
                  return Column(
                    children: [
                      _buildFeaturedDoctorCard(
                        context,
                        id: doctor['id'],
                        name: doctor['name'],
                        specialty: doctor['specialty'],
                        avatarUrl: doctor['avatar_url'],
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildStandardDoctorCard(
                    context,
                    id: doctor['id'],
                    name: doctor['name'],
                    specialty: doctor['specialty'],
                    rating: doctor['rating'].toString(),
                    status: doctor['status'],
                    avatarUrl: doctor['avatar_url'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search doctor or specialty...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardDoctorCard(
      BuildContext context, {
        required String id,
        required String name,
        required String specialty,
        required String rating,
        required String status,
        required String? avatarUrl,
      }) {
    bool isOnline = status.toLowerCase() == 'active';
    String statusText = isOnline ? 'Online' : '15m ago';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? Image.network(avatarUrl, width: 65, height: 65, fit: BoxFit.cover)
                : const Image(image: AssetImage('assets/images/default_avatar.png'), width: 65, height: 65, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A394A))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A394A))),
                Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientChatScreen(doctorName: name, doctorId: id),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE8F1F9),
                  child: const Icon(Icons.chat_bubble, color: Color(0xFF0061C4), size: 18),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline ? const Color(0xFFE8F5E9) : const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDoctorCard(
      BuildContext context, {
        required String id,
        required String name,
        required String specialty,
        required String? avatarUrl,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0061C4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'MOST BOOKED',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$specialty • 12 years exp.',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(avatarUrl, width: 65, height: 65, fit: BoxFit.cover)
                    : const Image(image: AssetImage('assets/images/default_avatar.png'), width: 65, height: 65, fit: BoxFit.cover),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientChatScreen(doctorName: name, doctorId: id),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0061C4),
              minimumSize: const Size(130, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Book Consult', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 15),
          Text("No registered doctors found.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}