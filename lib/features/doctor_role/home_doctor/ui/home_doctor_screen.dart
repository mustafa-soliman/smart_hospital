import 'package:flutter/material.dart';

class HomeDoctorScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeDoctorScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/default_avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      children: [
                        TextSpan(text: "Good Morning, ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "Dr.Ahmed", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0073F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.people, color: Colors.white, size: 28),
                          SizedBox(height: 12),
                          Text("Total Patients", style: TextStyle(color: Color(0xFFFBFBFC), fontSize: 13)),
                          SizedBox(height: 4),
                          Text("1,240", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_today_outlined, color: Color(0xFF0073F7), size: 28),
                          SizedBox(height: 12),
                          Text("Today's\nAppointments", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          SizedBox(height: 4),
                          Text("12", style: TextStyle(color: Color(0xFF0073F7), fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212529)),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onNavigate(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EDFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, color: Color(0xFF1B3A4B), size: 22),
                            SizedBox(width: 10),
                            Text(
                              "View\nSchedule",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onNavigate(3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, color: Color(0xFF0073F7), size: 22),
                            SizedBox(width: 10),
                            Text(
                              "Messages",
                              style: TextStyle(color: Color(0xFF0073F7), fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Appointments",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212529)),
                      ),
                      Text(
                        "Next 3 patients in queue",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => onNavigate(1),
                    child: const Text(
                      "View All",
                      style: TextStyle(color: Color(0xFF0073F7), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildAppointmentCard(
                name: "Akram Emad",
                time: "09:30 AM",
                status: "Confirmed",
                statusColor: const Color(0xFF2DCE89),
                statusBg: const Color(0xFFE2F7EE),
                onNavigate: onNavigate,
              ),
              _buildAppointmentCard(
                name: "Omar Reda",
                time: "10:15 AM",
                status: "Waiting",
                statusColor: const Color(0xFFFFB236),
                statusBg: const Color(0xFFFFF4E3),
                onNavigate: onNavigate,
              ),
              _buildAppointmentCard(
                name: "Ali Amer",
                time: "11:00 AM",
                status: "Confirmed",
                statusColor: const Color(0xFF2DCE89),
                statusBg: const Color(0xFFE2F7EE),
                onNavigate: onNavigate,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildAppointmentCard({
    required String name,
    required String time,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required Function(int) onNavigate,
  }) {
    return GestureDetector(
      onTap: () => onNavigate(4),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF212529))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
