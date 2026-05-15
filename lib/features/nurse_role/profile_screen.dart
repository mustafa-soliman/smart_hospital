import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'edit_profile_screen.dart';
import 'password_manager_screen.dart';
import 'logout_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Text(
                "My Profile",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1B3A4B)),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(color: Color(0xFF1B3A4B), shape: BoxShape.circle),
                              child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Text("Ahmed", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              _buildSectionTitle("GENERAL"),
              _buildProfileOption(
                icon: Icons.notifications_none_rounded,
                title: "Push Notifications",
                trailing: Switch(value: true, onChanged: (val) {}, activeColor: Colors.blue),
              ),
              _buildProfileOption(
                icon: Icons.language_rounded,
                title: "Language",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("English ", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              _buildSectionTitle("SECURITY"),
              _buildProfileOption(
                icon: Icons.shield_outlined,
                title: "Privacy Settings",
                trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
              ),
              _buildProfileOption(
                icon: Icons.lock_outline_rounded,
                title: "Change Password",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordManagerScreen())),
                trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () => showDialog(context: context, builder: (context) => const LogoutDialog()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  elevation: 0,
                  minimumSize: Size(double.infinity, 60.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red, size: 20.sp),
                    SizedBox(width: 10.w),
                    Text("Logout", style: TextStyle(color: Colors.red, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Text(title, style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required Widget trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: const Color(0xFF007BFF), size: 22.r),
            ),
            SizedBox(width: 15.w),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87))),
            trailing,
          ],
        ),
      ),
    );
  }
}