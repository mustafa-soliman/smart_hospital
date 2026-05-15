import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_details_screen.dart';

class PatientDoctorListScreen extends StatefulWidget {
  const PatientDoctorListScreen({super.key});

  @override
  State<PatientDoctorListScreen> createState() => _PatientDoctorListScreenState();
}

class _PatientDoctorListScreenState extends State<PatientDoctorListScreen> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['All', 'Cardiologist', 'Dentist', 'Neurologist'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Find Your Doctor', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildCategories(),
            const SizedBox(height: 20),
            _buildAvailabilityHeader(),
            Expanded(child: _buildDoctorList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('Search doctor or specialty...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.tune, color: Color(0xFF4A90E2)),
          )
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(categories[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('84 Doctors available', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A394A))),
          Row(children: [Text('Near me', style: TextStyle(color: Color(0xFF4A90E2))), Icon(Icons.location_on, color: Color(0xFF4A90E2), size: 16)]),
        ],
      ),
    );
  }

  Widget _buildDoctorList() {
    final List<Map<String, dynamic>> doctors = [
      {'name': 'Dr. Hamza Ahmed', 'specialty': 'Cardiologist • Heart Center', 'price': '200EGP', 'rating': '4.9'},
      {'name': 'Dr. Ahmed Ali', 'specialty': 'Neurologist • Brain Health Clinic', 'price': '250EGP', 'rating': '4.8'},
      {'name': 'Dr. Ali Eid', 'specialty': 'Dentist • Smile Studio', 'price': '300EGP', 'rating': '5.0'},
      {'name': 'Dr. Ahmed Gmal', 'specialty': 'Dermatologist • Smile Studio', 'price': '300EGP', 'rating': '5.0'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDoctorDetailsScreen())),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const Image(image: AssetImage('assets/images/default_avatar.png'), width: 85, height: 85, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doctors[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(6)),
                            child: Row(children: [const Icon(Icons.star, color: Color(0xFF4A90E2), size: 14), Text(doctors[index]['rating'], style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold, fontSize: 12))]),
                          ),
                        ],
                      ),
                      Text(doctors[index]['specialty'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${doctors[index]['price']} /visit", style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDoctorDetailsScreen())),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE3F2FD), foregroundColor: const Color(0xFF4A90E2), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
}