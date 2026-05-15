import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit profile", style: TextStyle(color: const Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(color: Color(0xFF1B3A4B), shape: BoxShape.circle),
                      child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            _buildEditField("Name", Icons.person_outline, "Ahmed"),
            _buildEditField("Email", Icons.lock_outline, "Ahmed@gmail.com"),
            _buildPhoneField(),
            _buildEditField("Date of Birth", null, ""),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                minimumSize: Size(double.infinity, 60.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              ),
              child: Text("Update Profile", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, IconData? icon, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 10.h),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone number", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.r), border: Border.all(color: Colors.grey.withValues(alpha: 0.2))),
            child: Row(
              children: [
                Image.asset('assets/images/egypt_flag.png', width: 24.w, errorBuilder: (c, e, s) => const Icon(Icons.flag)),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
                SizedBox(width: 10.w),
                const Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}