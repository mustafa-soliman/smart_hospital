import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordManagerScreen extends StatelessWidget {
  const PasswordManagerScreen({super.key});

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
        title: Text("Password Manager", style: TextStyle(color: const Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            _buildPasswordField("Current Password"),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text("Forgot Password ?", style: TextStyle(color: Colors.red))),
            ),
            _buildPasswordField("New Password"),
            _buildPasswordField("Confirm New Password"),
            SizedBox(height: 50.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                minimumSize: Size(double.infinity, 60.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              ),
              child: Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 10.h),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "************",
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
              suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
          ),
        ],
      ),
    );
  }
}