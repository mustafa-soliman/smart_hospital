import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/password_manager_screen.dart';
import 'package:smart_hospital/screens/sign_in_screen.dart';
import 'package:smart_hospital/features/patient_role/notifications_screen.dart';
import 'widgets/custom_popups.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A394A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            _buildSettingsOption(
              icon: Icons.lightbulb_outline,
              title: 'Notification Setting',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOption(
              icon: Icons.key_outlined,
              title: 'Password Manager',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasswordManagerScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOption(
              icon: Icons.person_outline,
              title: 'Delete Account',
              onTap: () {
                CustomPopups.showDeleteAccountPopup(
                  context,
                  onConfirm: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(userRole: 'Patient'),
                      ),
                          (route) => false,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          color: Color(0xFF7DA0B1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF1A394A),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1A394A)),
      onTap: onTap,
    );
  }
}