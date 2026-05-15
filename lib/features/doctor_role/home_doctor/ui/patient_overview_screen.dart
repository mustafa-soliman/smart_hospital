import 'package:flutter/material.dart';

class PatientOverviewScreen extends StatelessWidget {
  const PatientOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النص الرمادي الصغير في أعلى الشاشة
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Patients",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            // AppBar المخصص مع زر الرجوع الدائري
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Patient Overview",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // كارت المريض مع الصورة والنقطة الخضراء
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          const Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 2,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.green,
                                  child: SizedBox(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Akram Emad", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const Text("Age: 28 • Male", style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 10),
                                // ملصق الفحص السنوي مع أيقونة الحقيبة
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.medical_services_outlined, size: 14, color: Colors.blue),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Annual Wellness Checkup",
                                        style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text("SCHEDULE DETAILS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildScheduleTile(Icons.calendar_today_outlined, "DATE", "Tue, 17 Oct 2023"),
                        const SizedBox(width: 15),
                        _buildScheduleTile(Icons.access_time, "TIME", "09:30 AM"),
                      ],
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("CONSULTATION NOTES", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                        Icon(Icons.notes_outlined, color: Colors.grey[400]),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Patient has requested a general checkup and blood work. No prior major conditions reported.",
                            style: TextStyle(color: Colors.black87, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 15),
                          // مربع الفحص المطلوب مع أيقونة المستند
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.assignment_outlined, color: Colors.blue, size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  "Required: Comprehensive Metabolic Panel",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // شريط التنقل السفلي الموحد
      bottomNavigationBar: _buildBottomNav(2),
    );
  }

  Widget _buildScheduleTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5FB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 16),
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(int activeIndex) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A4B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home_outlined, color: activeIndex == 0 ? Colors.white : Colors.grey),
          Icon(Icons.calendar_month_outlined, color: activeIndex == 1 ? Colors.white : Colors.grey),
          Icon(Icons.people, color: activeIndex == 2 ? Colors.white : Colors.grey),
          Icon(Icons.settings_outlined, color: activeIndex == 3 ? Colors.white : Colors.grey),
        ],
      ),
    );
  }
}