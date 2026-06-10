import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/role_selection_screen.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'settings_screen.dart';
import 'favorite_doctors_screen.dart';
import 'widgets/custom_popups.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.12,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: const Color(0xFF1A394A),
                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mostafa Mohamed',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A394A)),
                    ),
                    const Text(
                      'mostafa.dev@gmail.com',
                      style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),


              _buildMenuOption(
                context,
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.favorite_border_rounded,
                title: 'Favorite Doctors',
                onTap: () {
                  // 👈 تم الربط هنا لفتح صفحة المفضلة بنجاح
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteDoctorsScreen()),
                  );
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),

              // زر تسجيل الخروج
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade50),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
                  onTap: () {
                    CustomPopups.showLogoutPopup(
                      context,
                      onConfirm: () {
                        Navigator.pop(context); // إغلاق الـ Popup أولاً

                        // 👈 طرد المستخدم لصفحة اختيار الرتب ومسح الـ Stack بالكامل لمنع الرجوع خلفاً
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                              (route) => false,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A394A).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1A394A), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A394A))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}