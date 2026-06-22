import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_doctor_screen.dart';
import 'schedule_doctor_screen.dart';
import 'patients_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _doctorProfile;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        if (mounted) {
          setState(() {
            _doctorProfile = data;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint("Error fetching doctor profile: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B3A4B)),
        ),
      );
    }

    final List<Widget> pages = [
      HomeDoctorScreen(onNavigate: _onItemTapped, doctorProfile: _doctorProfile),
      const ScheduleDoctorScreen(),
      PatientsScreen(onNavigate: _onItemTapped),
      ProfileScreen(doctorProfile: _doctorProfile),
    ];

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          _selectedIndex = 0;
        });
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3A4B),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                _buildNavIcon(Icons.calendar_month_outlined, Icons.calendar_month, 1),
                _buildNavIcon(Icons.people_outline, Icons.people, 2),
                _buildNavIcon(Icons.person_outline, Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData unselectedIcon, IconData selectedIcon, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          size: 26,
        ),
      ),
    );
  }
}