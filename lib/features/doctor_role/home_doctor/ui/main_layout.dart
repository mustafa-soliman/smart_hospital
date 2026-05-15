import 'package:flutter/material.dart';
import 'home_doctor_screen.dart';
import 'schedule_doctor_screen.dart';
import 'patients_screen.dart';
import 'profile_screen.dart';
import 'patient_overview_screen.dart'; // استيراد صفحة التفاصيل

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  // ميثود ثابتة عشان نقدر ننادي عليها من أي مكان في البرنامج لتغيير الصفحة
  static _MainLayoutState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainLayoutState>();

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // قائمة الصفحات (صفحة التفاصيل ترتيبها رقم 4 في القائمة)
  final List<Widget> _screens = [
    const HomeDoctorScreen(),
    const ScheduleDoctorScreen(),
    const PatientsScreen(),
    const ProfileScreen(),
    const PatientOverviewScreen(), // index 4
  ];

  // دالة لتغيير الصفحة من خارج الكلاس
  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3A4B),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.calendar_month, 1),
            // أيقونة المرضى هتنور لو إحنا في صفحة القائمة (2) أو صفحة التفاصيل (4)
            _buildNavItem(Icons.people, 2, alternativeIndex: 4),
            _buildNavItem(Icons.settings, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {int? alternativeIndex}) {
    bool isSelected = _selectedIndex == index || (alternativeIndex != null && _selectedIndex == alternativeIndex);
    return IconButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
        size: isSelected ? 28 : 24,
      ),
    );
  }
}