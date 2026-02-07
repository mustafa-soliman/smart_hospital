import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/profile_screen.dart'; // تأكد من وجود الملف

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // قائمة الصفحات التي تظهر عند الضغط على الشريط السفلي
  final List<Widget> _pages = [
    const HomeContent(),      // محتوى الصفحة الرئيسية
    const Center(child: Text("Appointments")),
    const Center(child: Text("Favorite Doctors")),
    const ProfileScreen(),    // صفحة الملف الشخصي التي صممناها
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // تبديل المحتوى بناءً على الاختيار

      // الشريط السفلي العائم بتصميم الكبسولة
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3A4B), // الكحلي الموحد
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, 0),
            _buildNavItem(Icons.calendar_month, 1),
            _buildNavItem(Icons.favorite_border, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Icon(
        icon,
        size: 28,
        color: _selectedIndex == index ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    );
  }
}

// ويدجت منفصل لمحتوى الصفحة الرئيسية لسهولة التعديل
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header: Profile Image & Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Hello Jogn',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.notifications_none, size: 28),
              ],
            ),
            const SizedBox(height: 30),

            // Search Bar & Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.tune),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Recommended Doctors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // هنا يمكنك إضافة List of Doctors لاحقاً
          ],
        ),
      ),
    );
  }
}