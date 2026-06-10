import 'package:flutter/material.dart';
import 'nurse_chat_screen.dart';

class SelectDoctorScreen extends StatefulWidget {
  const SelectDoctorScreen({super.key});

  @override
  State<SelectDoctorScreen> createState() => _SelectDoctorScreenState();
}

class _SelectDoctorScreenState extends State<SelectDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allDoctors = [
    {
      'name': 'Dr. Ahmed Gmal',
      'specialty': 'Cardiologist',
      'rating': '5.0',
      'status': 'Online',
      'statusColor': const Color(0xFF53C07F),
      'statusBg': const Color(0xFFE8F8EE),
    },
    {
      'name': 'Dr. Ali Eid',
      'specialty': 'Dentist',
      'rating': '5.0',
      'status': 'Away',
      'statusColor': const Color(0xFF94A3B8),
      'statusBg': const Color(0xFFF1F5F9),
    },
    {
      'name': 'Dr. Hamza Ahmed',
      'specialty': 'Cardiologist',
      'rating': '4.9',
      'status': 'Online',
      'statusColor': const Color(0xFF53C07F),
      'statusBg': const Color(0xFFE8F8EE),
    },
    {
      'name': 'Dr. Ahmed Ali',
      'specialty': 'Neurologist',
      'rating': '4.8',
      'status': '15m ago',
      'statusColor': const Color(0xFF94A3B8),
      'statusBg': const Color(0xFFF1F5F9),
    },
  ];

  List<Map<String, dynamic>> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = _allDoctors;
  }

  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = _allDoctors;
      } else {
        _filteredDoctors = _allDoctors
            .where((doc) =>
        doc['name'].toLowerCase().contains(query.toLowerCase()) ||
            doc['specialty'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Select Doctor',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterDoctors,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Search doctor or specialty...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Experts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    '${_filteredDoctors.length} Found',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF007AFF)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _filteredDoctors[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NurseChatScreen(doctorName: doctor['name']),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 38,
                              backgroundColor: Color(0xFFF1F5F9),
                              backgroundImage: AssetImage('assets/images/default_avatar.png'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Color(0xFFFFB300), size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        doctor['rating'],
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doctor['name'],
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doctor['specialty'],
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NurseChatScreen(doctorName: doctor['name']),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF007AFF), size: 20),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: doctor['statusBg'],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    doctor['status'],
                                    style: TextStyle(
                                      color: doctor['statusColor'],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}