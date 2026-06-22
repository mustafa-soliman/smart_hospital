import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'password_manager_screen.dart';
import 'Logout_Dialog.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? doctorProfile;
  const ProfileScreen({super.key, this.doctorProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final String doctorName = widget.doctorProfile?['full_name'] ?? 'Doctor';
    final String userRole = widget.doctorProfile?['role'] ?? 'doctor';
    final String? avatarUrl = widget.doctorProfile?['avatar_url'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
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
                      decoration: const BoxDecoration(color: Color(0xFF1B3A4B), shape: BoxShape.circle),
                      child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(doctorName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildSectionHeader("GENERAL"),
              _buildSettingItem(
                icon: Icons.notifications_none,
                title: "Push Notifications",
                trailing: Switch(
                  value: isNotificationEnabled,
                  activeThumbColor: Colors.blue,
                  onChanged: (val) => setState(() => isNotificationEnabled = val),
                ),
              ),
              _buildSettingItem(icon: Icons.language, title: "Language", trailingText: "English"),
              const SizedBox(height: 20),
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
              const SizedBox(height: 35),
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
                    backgroundColor: const Color(0xFFFFEBEE),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

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
        decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}