import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_list_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_details_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_emergency_category_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_chat_select_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 25),
              _buildLabResultsCard(),
              const SizedBox(height: 25),
              _buildQuickActionsGrid(context),
              const SizedBox(height: 30),
              const Text(
                'Top Doctors',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A394A),
                ),
              ),
              const SizedBox(height: 15),
              _buildDoctorsList(context),
              const SizedBox(height: 20),
              _buildLastCheckoutCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Ahmed',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                )
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // هنا سيتم كتابة لوجيك الفلترة والاستعلام من الداتابيز مستقبلاً بناءً على النص القادم في الـ value
              },
              decoration: const InputDecoration(
                hintText: 'Search doctor or specialty...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PatientDoctorListScreen()),
            );
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                )
              ],
            ),
            child: const Icon(Icons.tune, color: Color(0xFF4A90E2)),
          ),
        )
      ],
    );
  }

  Widget _buildLabResultsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB), width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 24),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lab Results Ready',
                  style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Your blood panel results from Oct 15 are now available in records.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.4,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientDoctorListScreen()),
          ),
          child: _buildActionItem(Icons.medical_services_outlined, 'Book Appointment', Colors.blue),
        ),
        _buildActionItem(Icons.description_outlined, 'Medical Records', Colors.blue),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientChatSelectScreen()),
          ),
          child: _buildActionItem(Icons.chat_bubble_outline, 'Chat with Doctor', Colors.blue),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientEmergencyCategoryScreen()),
          ),
          child: _buildActionItem(Icons.report_gmailerrorred_outlined, 'Emergency', Colors.red),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    final List<Map<String, dynamic>> doctors = [
      {'name': 'Dr. Hamza Ahmed', 'specialty': 'Cardiologist • Heart Center', 'price': '200EGP', 'rating': '4.9'},
      {'name': 'Dr. Ahmed Ali', 'specialty': 'Neurologist • Brain Health Clinic', 'price': '250EGP', 'rating': '4.8'},
      {'name': 'Dr. Ali Eid', 'specialty': 'Dentist • Smile Studio', 'price': '300EGP', 'rating': '5.0'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientDoctorDetailsScreen()),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const Image(
                    image: AssetImage('assets/images/default_avatar.png'),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctors[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.blue, size: 14),
                                Text(
                                  doctors[index]['rating'],
                                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(doctors[index]['specialty'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: doctors[index]['price'],
                                  style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const TextSpan(text: ' /visit', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PatientDoctorDetailsScreen()),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE3F2FD),
                              foregroundColor: const Color(0xFF4A90E2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('BOOK NOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLastCheckoutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF78858F), borderRadius: BorderRadius.circular(16)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Last Full Checkup', style: TextStyle(fontSize: 12, color: Colors.white70)),
              SizedBox(height: 4),
              Text('Oct 15, 2023', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          Icon(Icons.calendar_today_outlined, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}