import 'package:flutter/material.dart';
import 'schedule_doctor_screen.dart';
import 'patients_screen.dart';
import 'profile_screen.dart';

class HomeDoctorScreen extends StatelessWidget {
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Good Morning,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text("Dr. Ahmed", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: _buildStatCard(title: "Total Patients", value: "1,240", icon: Icons.people_outline, color: const Color(0xFF007BFF), textColor: Colors.white)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildStatCard(title: "Today's\nAppointments", value: "12", icon: Icons.calendar_today_outlined, color: Colors.white, textColor: Colors.black87, iconColor: const Color(0xFF007BFF))),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildActionCard("View\nSchedule", Icons.calendar_month, const Color(0xFFE3EBFF), const Color(0xFF1B3A4B))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildActionCard("Messages", Icons.chat_bubble_outline, Colors.white, const Color(0xFF007BFF))),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Upcoming Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Next 3 patients in queue", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 15),
              _buildAppointmentItem("Akram Emad", "09:30 AM", "Confirmed", Colors.green),
              _buildAppointmentItem("Omar Reda", "10:15 AM", "Waiting", Colors.orange),
              _buildAppointmentItem("Ali Amer", "11:00 AM", "Confirmed", Colors.green),
            ],
          ),
        ),
      ),
      // تم حذف الـ bottomNavigationBar من هنا
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color, required Color textColor, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: iconColor ?? textColor, size: 30), const SizedBox(height: 15), Text(title, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13)), Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color bgColor, Color themeColor) {
    return Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(18)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: themeColor, size: 24), const SizedBox(width: 10), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: themeColor, fontSize: 14))]));
  }

  Widget _buildAppointmentItem(String name, String time, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(children: [const CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://via.placeholder.com/150')), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Row(children: [const Icon(Icons.access_time, size: 14, color: Colors.grey), const SizedBox(width: 5), Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13))])])), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)))]),
    );
  }
}