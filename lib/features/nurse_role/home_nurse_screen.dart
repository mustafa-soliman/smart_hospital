import 'package:flutter/material.dart';
import 'patient_details_nurse_screen.dart';
import 'urgent_alerts_screen.dart';
import 'select_doctor_screen.dart';

class PatientModel {
  final String id;
  final String name;
  final String room;
  final String status;
  final String? subtitle;
  final IconData actionIcon;
  final List<IconData>? leftIcons;

  PatientModel({
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    this.subtitle,
    required this.actionIcon,
    this.leftIcons,
  });
}

class HomeNurseScreen extends StatefulWidget {
  const HomeNurseScreen({super.key});

  @override
  State<HomeNurseScreen> createState() => _HomeNurseScreenState();
}

class _HomeNurseScreenState extends State<HomeNurseScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<PatientModel> _allPatients = [
    PatientModel(
      id: '1',
      name: 'Akram Emad',
      room: 'ROOM 302',
      status: 'STABLE',
      actionIcon: Icons.refresh_rounded,
      leftIcons: [Icons.analytics_outlined, Icons.link],
    ),
    PatientModel(
      id: '2',
      name: 'Omar Reda',
      room: 'ROOM 305',
      status: 'CRITICAL',
      subtitle: 'Vitals Unstable',
      actionIcon: Icons.edit_outlined,
    ),
    PatientModel(
      id: '3',
      name: 'Ali Amer',
      room: 'ROOM 212',
      status: 'NEEDS ATTENTION',
      subtitle: 'Pending Lab Results',
      actionIcon: Icons.refresh_rounded,
    ),
    PatientModel(
      id: '4',
      name: 'Emad Ali',
      room: 'ROOM 401',
      status: 'STABLE',
      subtitle: 'Ready for discharge',
      actionIcon: Icons.edit_outlined,
    ),
  ];

  Color _getBadgeBg(String status) {
    switch (status) {
      case 'STABLE':
        return const Color(0xFFE8F8EE);
      case 'CRITICAL':
        return const Color(0xFFFDEBEB);
      case 'NEEDS ATTENTION':
        return const Color(0xFFFEF5E6);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getBadgeTextColor(String status) {
    switch (status) {
      case 'STABLE':
        return const Color(0xFF53C07F);
      case 'CRITICAL':
        return const Color(0xFFE05858);
      case 'NEEDS ATTENTION':
        return const Color(0xFFD4973B);
      default:
        return Colors.grey.shade700;
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 14),
                  RichText(
                    text: const TextSpan(
                      text: 'Good Morning, ',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Nurse',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Search patient or room...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateTo(const UrgentAlertsScreen()),
                      child: Container(
                        height: 125,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF007AFF).withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.groups_outlined, color: Colors.white, size: 28),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Patients',
                                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '1,240',
                                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 125,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.calendar_today_outlined, color: Color(0xFF007AFF), size: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Appointments",
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '12',
                                style: TextStyle(color: Color(0xFF007AFF), fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _allPatients.length,
                  itemBuilder: (context, index) {
                    final patient = _allPatients[index];
                    final String status = patient.status;

                    return GestureDetector(
                      onTap: () {
                        _navigateTo(PatientDetailsNurseScreen(
                          patientName: patient.name,
                          roomNumber: patient.room,
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  patient.room,
                                  style: const TextStyle(
                                    color: Color(0xFF007AFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getBadgeBg(status),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: _getBadgeTextColor(status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              patient.name,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: patient.subtitle != null
                                      ? Row(
                                    children: [
                                      Icon(
                                        status == 'CRITICAL' ? Icons.brightness_1 : Icons.assignment_outlined,
                                        color: _getBadgeTextColor(status),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        patient.subtitle!,
                                        style: TextStyle(
                                          color: _getBadgeTextColor(status),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      if (patient.leftIcons != null) ...[
                                        Icon(patient.leftIcons![0], color: const Color(0xFF94A3B8), size: 22),
                                        const SizedBox(width: 10),
                                        Transform.rotate(
                                          angle: 0.7,
                                          child: Icon(patient.leftIcons![1], color: const Color(0xFF94A3B8), size: 22),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _navigateTo(const SelectDoctorScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: status == 'CRITICAL' ? const Color(0xFFFDEBEB) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      patient.actionIcon,
                                      color: status == 'CRITICAL' ? const Color(0xFFE05858) : const Color(0xFF1E293B),
                                      size: 22,
                                    ),
                                  ),
                                )
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