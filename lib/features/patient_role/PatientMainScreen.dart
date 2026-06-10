import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/home_patient_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_appointments_screen.dart';
import 'package:smart_hospital/features/patient_role/favorite_doctors_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_profile_screen.dart'; // مسار ملف البروفايل الصحيح من مشروعك

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({super.key});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PatientHomeScreen(),
    const PatientAppointmentsScreen(),
    const FavoriteDoctorsScreen(),
    const PatientProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double navBarHeight = bottomPadding > 0 ? 68.0 : 74.0;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          height: navBarHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1A394A),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFF49CDCB),
              unselectedItemColor: Colors.white.withOpacity(0.5),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 26,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Appointments'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}