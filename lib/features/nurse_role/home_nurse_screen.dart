import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'urgent_alerts_screen.dart';
import 'patient_details_nurse_screen.dart';
import 'profile_screen.dart';

class HomeNurseScreen extends StatelessWidget {
  const HomeNurseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الجزء العلوي: ترحيب مع الصورة الافتراضية
              Row(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Good Morning,", style: TextStyle(fontSize: 18.sp, color: Colors.black87)),
                      Text("Nurse", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3A4B))),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              // شريط البحث
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search patient or room...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    icon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              // كروت الإحصائيات
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "Total Patients",
                      value: "1,240",
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF007BFF),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: _buildStatCard(
                      title: "Today's\nAppointments",
                      value: "12",
                      icon: Icons.calendar_today_rounded,
                      color: Colors.white,
                      textColor: Colors.black87,
                      iconColor: const Color(0xFF007BFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              // قائمة غرف المرضى
              _buildNurseRoomCard(
                context: context,
                room: "ROOM 302",
                name: "Akram Emad",
                status: "STABLE",
                statusColor: Colors.green,
                infoIcon1: Icons.show_chart,
                infoIcon2: Icons.link,
                actionIcon: Icons.sync,
                actionBgColor: const Color(0xFFE3F2FD),
              ),
              _buildNurseRoomCard(
                context: context,
                room: "ROOM 305",
                name: "Omar Reda",
                status: "CRITICAL",
                statusColor: Colors.red,
                alertText: "Vitals Unstable",
                alertIcon: Icons.wb_sunny_rounded,
                actionIcon: Icons.edit_outlined,
                actionBgColor: const Color(0xFFFFEBEE),
                actionIconColor: Colors.red,
              ),
              _buildNurseRoomCard(
                context: context,
                room: "ROOM 212",
                name: "Ali Amer",
                status: "NEEDS ATTENTION",
                statusColor: Colors.orange,
                alertText: "Pending Lab Results",
                alertIcon: Icons.access_time,
                actionIcon: Icons.sync,
                actionBgColor: const Color(0xFFE3F2FD),
              ),
              _buildNurseRoomCard(
                context: context,
                room: "ROOM 401",
                name: "Emad Ali",
                status: "STABLE",
                statusColor: Colors.green,
                alertText: "Ready for discharge",
                alertIcon: Icons.assignment_outlined,
                actionIcon: Icons.edit_outlined,
                actionBgColor: const Color(0xFFE3F2FD),
                actionIconColor: Colors.blue,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      // الشريط السفلي مع ربط صفحة البروفايل والتنبيهات
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 25.h),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3A4B),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home, color: Colors.white, size: 28),
            Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 26.r),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UrgentAlertsScreen())),
              child: Icon(Icons.people_outline, color: Colors.grey, size: 26.r),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
              child: Icon(Icons.settings_outlined, color: Colors.grey, size: 26.r),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color, required Color textColor, Color? iconColor}) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? textColor, size: 28.r),
          SizedBox(height: 15.h),
          Text(title, style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 12.sp)),
          Text(value, style: TextStyle(color: textColor, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNurseRoomCard({
    required BuildContext context,
    required String room,
    required String name,
    required String status,
    required Color statusColor,
    String? alertText,
    IconData? alertIcon,
    IconData? infoIcon1,
    IconData? infoIcon2,
    required IconData actionIcon,
    required Color actionBgColor,
    Color actionIconColor = Colors.blue
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDetailsNurseScreen())),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(room, style: TextStyle(color: const Color(0xFF007BFF), fontWeight: FontWeight.bold, fontSize: 13.sp)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(name, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (infoIcon1 != null) Icon(infoIcon1, size: 20.r, color: Colors.blue.withValues(alpha: 0.2)),
                    if (infoIcon1 != null) SizedBox(width: 10.w),
                    if (infoIcon2 != null) Icon(infoIcon2, size: 20.r, color: Colors.blue.withValues(alpha: 0.2)),
                    if (alertText != null) Row(
                      children: [
                        Icon(alertIcon, size: 18.r, color: status == "CRITICAL" ? Colors.red : Colors.grey),
                        SizedBox(width: 8.w),
                        Text(alertText, style: TextStyle(color: status == "CRITICAL" ? Colors.red : Colors.grey, fontSize: 12.sp)),
                      ],
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(color: actionBgColor, borderRadius: BorderRadius.circular(12.r)),
                    child: Icon(actionIcon, color: actionIconColor, size: 22.r)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}