import 'package:flutter/material.dart';

class ScheduleDoctorScreen extends StatelessWidget {
  const ScheduleDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC), // خلفية الصفحة الفاتحة جداً
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Schedule",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header: الشهر وزر اليوم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "October 2023",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Today", style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // قائمة الأيام الأفقية
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDateItem("MON", "16", false),
                  _buildDateItem("TUE", "17", true), // اليوم المختار (أزرق)
                  _buildDateItem("WED", "18", false),
                  _buildDateItem("THU", "19", false),
                  _buildDateItem("FRI", "20", false),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // عنوان المواعيد القادمة مع الفلاتر
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Appointments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.tune, color: Colors.grey, size: 18),
                    SizedBox(width: 5),
                    Text("Filters", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // كروت المواعيد
            _buildDetailedCard(
              name: "Akram Emad",
              time: "09:30 AM",
              task: "Annual Wellness Checkup",
              status: "CONFIRMED",
              statusColor: Colors.green,
              icon: Icons.calendar_month,
              hasBorder: true, // الخط الأزرق السفلي
            ),
            _buildDetailedCard(
              name: "Omar Reda",
              time: "10:15 AM",
              task: "Medication Review",
              status: "PENDING",
              statusColor: Colors.orange,
              icon: Icons.medical_services_outlined,
            ),
            _buildDetailedCard(
              name: "Ali Amer",
              time: "11:00 AM",
              task: "Medication Review",
              status: "CONFIRMED",
              statusColor: Colors.green,
              icon: Icons.link,
            ),

            const SizedBox(height: 10),

            // كارت إضافة موعد (Add Slot)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text("Add Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text("12:30 PM - 01:00 PM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // تم إزالة الـ BottomNavigationBar من هنا ليعمل من خلال الـ MainLayout
    );
  }

  // ويدجت التاريخ
  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Text(date, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ويدجت كروت المواعيد
  Widget _buildDetailedCard({
    required String name,
    required String time,
    required String task,
    required String status,
    required Color statusColor,
    required IconData icon,
    bool hasBorder = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, color: Colors.blue, size: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(task, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          if (hasBorder)
            Container(
                height: 4,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                )
            ),
        ],
      ),
    );
  }
}