import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatelessWidget {
  // متغيرات لاستقبال بيانات الدكتور من صفحة تسجيل الدخول أو الباك اند
  final String doctorName;
  final String doctorImage;
  final String specialty;

  const DoctorHomeScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Welcome Section)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(doctorImage),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome,", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            Text("Dr. $doctorName", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_none, size: 28),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search patients or history...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 3. Stats Banner (The Navy Blue Card)
              _buildStatsBanner(),

              // 4. Categories Section (Icons Row)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildCategoriesRow(),

              // 5. Appointments List (The cards with the arrow button)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Today's Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildAppointmentList(),

              const SizedBox(height: 100), // مساحة إضافية عشان الـ Bottom Nav ميتغطيش
            ],
          ),
        ),
      ),

      // 6. Floating Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- دالة بناء بانر الإحصائيات ---
  Widget _buildStatsBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A4B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("14", "Patients"),
          _statItem("3", "Operations"),
          _statItem("4.8", "Rating"),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // --- دالة بناء الأقسام ---
  Widget _buildCategoriesRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _categoryItem(Icons.medical_services, "Dentistry", Colors.red[100]!),
          _categoryItem(Icons.favorite, "Cardio", Colors.green[100]!),
          _categoryItem(Icons.air, "Pulmono", Colors.orange[100]!),
          _categoryItem(Icons.person, "General", Colors.purple[100]!),
        ],
      ),
    );
  }

  Widget _categoryItem(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // --- دالة بناء قائمة المواعيد (كروت الطبيب بنفس ستايل اليوزر) ---
  Widget _buildAppointmentList() {
    // بيانات تجريبية (Mock Data)
    final patients = [
      {'name': 'Ahmed Mustafa', 'time': '10:30 AM'},
      {'name': 'Sara Soliman', 'time': '11:45 AM'},
      {'name': 'Mohamed Ali', 'time': '01:15 PM'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                width: 65, height: 65,
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.person, color: Colors.grey, size: 35),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patients[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Appointment: ${patients[index]['time']}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              // الزر الدائري بالسهم كما في التصميم
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFF1B3A4B), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- دالة بناء الشريط السفلي العائم ---
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A4B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.white, size: 28),
          Icon(Icons.calendar_month, color: Colors.white54, size: 28),
          Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 28),
          Icon(Icons.person_outline, color: Colors.white54, size: 28),
        ],
      ),
    );
  }
}