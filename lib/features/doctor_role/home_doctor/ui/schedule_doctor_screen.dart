import 'package:flutter/material.dart';

class ScheduleDoctorScreen extends StatefulWidget {
  const ScheduleDoctorScreen({super.key});

  @override
  State<ScheduleDoctorScreen> createState() => _ScheduleDoctorScreenState();
}

class _ScheduleDoctorScreenState extends State<ScheduleDoctorScreen> {
  DateTime selectedDate = DateTime(2023, 10, 17);

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onTodayPressed() {
    setState(() {
      selectedDate = DateTime(2023, 10, 17);
    });
  }

  void _onAddSlotPressed() {}

  void _onFilterPressed() {}

  void _onAppointmentTap(String patientName) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "October 2023",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                ),
                TextButton(
                  onPressed: _onTodayPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Today", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDateTile("Mon", "16", DateTime(2023, 10, 16)),
                  _buildDateTile("Tue", "17", DateTime(2023, 10, 17)),
                  _buildDateTile("Wed", "18", DateTime(2023, 10, 18)),
                  _buildDateTile("Thu", "19", DateTime(2023, 10, 19)),
                  _buildDateTile("Fri", "20", DateTime(2023, 10, 20)),
                  _buildDateTile("Sat", "21", DateTime(2023, 10, 21)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming Appointments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: _onFilterPressed,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildAppointmentCard(
              status: "CONFIRMED",
              statusColor: Colors.green,
              time: "09:30 AM",
              name: "Akram Emad",
              task: "Annual Wellness Checkup",
              hasBorder: true,
              icon: Icons.calendar_today_outlined,
            ),
            _buildAppointmentCard(
              status: "PENDING",
              statusColor: Colors.orange,
              time: "11:00 AM",
              name: "Omar Reda",
              task: "Medication Review",
              hasBorder: false,
              icon: Icons.medical_services_outlined,
            ),
            GestureDetector(
              onTap: _onAddSlotPressed,
              child: CustomPaint(
                painter: DashedBorderPainter(color: Colors.blue.withValues(alpha: 0.4)),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.add, color: Colors.blue, size: 28),
                      SizedBox(height: 8),
                      Text("Add Slot", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile(String day, String date, DateTime tileDate) {
    final bool isSelected = DateUtils.isSameDay(selectedDate, tileDate);
    return GestureDetector(
      onTap: () => _onDateSelected(tileDate),
      child: Container(
        width: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : const Color(0xFFF1F5FB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              date,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              const CircleAvatar(radius: 2, backgroundColor: Colors.white),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String status,
    required Color statusColor,
    required String time,
    required String name,
    required String task,
    required bool hasBorder,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _onAppointmentTap(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: Colors.blue, size: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  Text(task, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage('assets/images/default_avatar.png'),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue.withValues(alpha: 0.7)),
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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );

    final path = Path()..addRRect(rrect);
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}