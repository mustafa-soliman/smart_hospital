import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'patient_details_nurse_screen.dart';

class UrgentAlertsScreen extends StatelessWidget {
  const UrgentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Urgent Alerts", style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(child: _buildSummaryCard(icon: Icons.warning_amber_rounded, count: "03", label: "Critical Issues", color: Colors.red)),
                SizedBox(width: 15.w),
                Expanded(child: _buildSummaryCard(icon: Icons.notifications_none_rounded, count: "12", label: "Attention Needed", color: const Color(0xFF8D3B08))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                _buildAlertCard(context, patientName: "Sara Ahmed", roomInfo: "Room 402 • 10:15 AM", status: "CRITICAL", statusColor: Colors.red, vitalLabel: "High Heart Rate", vitalValue: "142", unit: "BPM", icon: Icons.monitor_heart_outlined, iconBg: const Color(0xFFFFEBEE)),
                _buildAlertCard(context, patientName: "Ola Ali", roomInfo: "Room 315 • 10:08 AM", status: "NEEDS ATTENTION", statusColor: const Color(0xFF8D3B08), vitalLabel: "Low O2 Saturation", vitalValue: "91", unit: "%", icon: Icons.air, iconBg: const Color(0xFFFFF3E0)),
                _buildAlertCard(context, patientName: "Ragab Reda", roomInfo: "Room 408 • 09:55 AM", status: "CRITICAL", statusColor: Colors.red, vitalLabel: "Elevated Temperature", vitalValue: "103.4", unit: "°F", icon: Icons.thermostat, iconBg: const Color(0xFFFFEBEE)),
                _buildAlertCard(context, patientName: "Amer Omar", roomInfo: "Room 212 • 09:42 AM", status: "NEEDS ATTENTION", statusColor: const Color(0xFF8D3B08), vitalLabel: "Elevated BP", vitalValue: "158/94", unit: "mmHg", icon: Icons.speed_outlined, iconBg: const Color(0xFFFFF3E0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String count, required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 24.r), SizedBox(height: 8.h), Text(count, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey))]),
    );
  }

  Widget _buildAlertCard(BuildContext context, {required String patientName, required String roomInfo, required String status, required Color statusColor, required String vitalLabel, required String vitalValue, required String unit, required IconData icon, required Color iconBg}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDetailsNurseScreen())),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
        child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12.r)), child: Icon(icon, color: statusColor, size: 24.r)), SizedBox(width: 12.w), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(patientName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)), Text(roomInfo, style: TextStyle(fontSize: 12.sp, color: Colors.grey))])]), Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12.r)), child: Text(status, style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)))]), SizedBox(height: 15.h), Container(padding: EdgeInsets.all(15.r), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(15.r)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(vitalLabel, style: TextStyle(fontSize: 13.sp, color: Colors.grey[700])), Row(children: [Text(vitalValue, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: statusColor)), SizedBox(width: 4.w), Text(unit, style: TextStyle(fontSize: 10.sp, color: Colors.grey))])]))]),
      ),
    );
  }
}