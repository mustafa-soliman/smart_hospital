import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'password_manager_screen.dart';
import 'logout_Dialog.dart'; // تأكد من مطابقة اسم الملف لديك

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationEnabled = true;
  final String userRole = "Doctor";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء بالكامل
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // عنوان الصفحة
              const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A4B),
                ),
              ),
              const SizedBox(height: 30),

              // قسم الصورة الشخصية مع أيقونة التعديل
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B3A4B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Ahmed",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // قسم الإعدادات العامة (GENERAL)
              _buildSectionHeader("GENERAL"),
              _buildSettingItem(
                icon: Icons.notifications_none,
                title: "Push Notifications",
                trailing: Switch(
                  value: isNotificationEnabled,
                  activeColor: Colors.blue,
                  onChanged: (val) => setState(() => isNotificationEnabled = val),
                ),
              ),
              _buildSettingItem(
                icon: Icons.language,
                title: "Language",
                trailingText: "English",
              ),

              const SizedBox(height: 20),

              // قسم الأمان (SECURITY)
              _buildSectionHeader("SECURITY"),
              _buildSettingItem(icon: Icons.shield_outlined, title: "Privacy Settings"),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PasswordManagerScreen()),
                  );
                },
              ),

              const SizedBox(height: 30),

              // زر تسجيل الخروج بتصميمه الجديد
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => LogoutDialog(userRole: userRole),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE), // لون وردي فاتح
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // تم حذف الـ bottomNavigationBar للسماح للـ MainLayout بإدارته
    );
  }

  // ميثود بناء عناوين الأقسام
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ميثود بناء عناصر القائمة بتصميم متناسق
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05), // خلفية زرقاء خفيفة للأيقونة
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}