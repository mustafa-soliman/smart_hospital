import 'package:flutter/material.dart';
import 'home_nurse_screen.dart';
import 'urgent_alerts_screen.dart';
import 'profile_screen.dart';
import 'select_doctor_screen.dart';

class NurseDashboardWrapper extends StatefulWidget {
  const NurseDashboardWrapper({super.key});

  @override
  State<NurseDashboardWrapper> createState() => _NurseDashboardWrapperState();
}

class _NurseDashboardWrapperState extends State<NurseDashboardWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeNurseScreen(),
    const UrgentAlertsScreen(),
    const SelectDoctorScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF132530),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 28),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny_outlined, size: 28),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}