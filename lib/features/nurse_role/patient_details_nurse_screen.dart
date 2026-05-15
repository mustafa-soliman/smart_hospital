import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDetailsNurseScreen extends StatelessWidget {
  const PatientDetailsNurseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "Patient Details",
          style: TextStyle(color: const Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Akram Emad",
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.door_front_door_outlined, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Text("Room 302", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Health Vitals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: _buildVitalCard(
                    icon: Icons.favorite,
                    iconColor: Colors.red,
                    value: "72",
                    unit: "bpm",
                    label: "Heart Rate",
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _buildVitalCard(
                    icon: Icons.device_thermostat,
                    iconColor: Colors.blue,
                    value: "98.6",
                    unit: "°F",
                    label: "Temperature",
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nurse Observations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text("View History", style: TextStyle(color: Colors.blue, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient is responsive and vitals are stable. Scheduled for physical therapy at 2 PM.",
                    style: TextStyle(color: Colors.black87, height: 1.5, fontSize: 13.sp),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        child: Text("NJ", style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 8.w),
                      Text("Updated 14m ago by Nurse Jane", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () => _showUpdateStatusSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text("Update Status", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
            SizedBox(height: 15.h),
            OutlinedButton(
              onPressed: () => _showAddNoteSheet(context),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 55.h),
                side: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                backgroundColor: Colors.blue.withValues(alpha: 0.02),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text("Add Note", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard({required IconData icon, required Color iconColor, required String value, required String unit, required String label}) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20.r),
          SizedBox(height: 15.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 4.w),
              Text(unit, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        ],
      ),
    );
  }

  void _showUpdateStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(25.r, 10.r, 25.r, 25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50.w, height: 5.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
            SizedBox(height: 20.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, size: 24.r))),
                Text("Update Status", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3A4B))),
              ],
            ),
            SizedBox(height: 20.h),
            Text("Select the current clinical status for Akram Emad.", style: TextStyle(color: Colors.black54, fontSize: 14.sp)),
            SizedBox(height: 30.h),
            _buildStatusOption(icon: Icons.check_circle, title: "Stable", subTitle: "Vitals within normal range", color: Colors.green, isSelected: true),
            _buildStatusOption(icon: Icons.error, title: "Needs Attention", subTitle: "Minor fluctuations in vitals", color: Colors.orange, isSelected: false),
            _buildStatusOption(icon: Icons.warning, title: "Critical", subTitle: "Urgent medical intervention needed", color: Colors.red, isSelected: false),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessAlert(context, "Status updated successfully", false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: Size(double.infinity, 60.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
              child: Text("Save State", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: const Color(0xFF007BFF), fontSize: 16.sp, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(25.r, 10.r, 25.r, MediaQuery.of(context).viewInsets.bottom + 25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50.w, height: 5.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Note", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3A4B))),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: Colors.blue),
                    SizedBox(width: 5.w),
                    Text("12 Oct, 10:45 AM", style: TextStyle(color: Colors.blue, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Align(alignment: Alignment.centerLeft, child: Text("Eleanor Vance • Ward 4B", style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
            SizedBox(height: 20.h),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write note here...",
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 25.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessAlert(context, "Note saved successfully", true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: Size(double.infinity, 60.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
              child: Text("Save Note", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: const Color(0xFF007BFF), fontSize: 16.sp, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption({required IconData icon, required String title, required String subTitle, required Color color, required bool isSelected}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? const Color(0xFF007BFF) : Colors.grey.withValues(alpha: 0.1), width: 2),
      ),
      child: Row(
        children: [
          Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24.r)),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text(subTitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ],
            ),
          ),
          Container(width: 24.r, height: 24.r, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFF007BFF) : Colors.grey[300]!, width: isSelected ? 7 : 2))),
        ],
      ),
    );
  }

  void _showSuccessAlert(BuildContext context, String message, bool isNote) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: isNote ? null : Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(Icons.check, color: Colors.green, size: 18.sp),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message, style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        if (isNote) Text("History updated in real-time", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(), icon: Icon(Icons.close, color: Colors.grey, size: 18.sp)),
                ],
              ),
              if (isNote) ...[
                SizedBox(height: 10.h),
                Container(height: 4.h, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)))),
              ]
            ],
          ),
        ),
      ),
    );
  }
}