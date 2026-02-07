import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الجزء العلوي: الخلفية المنحنية والصورة الشخصية
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/hospital_bg.png'), fit: BoxFit.cover),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 60, backgroundColor: Colors.white,
                    child: CircleAvatar(radius: 55, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, size: 60, color: Colors.grey)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text('JOGN.DOE.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
            const Text('+91 123-456-7890', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            // القائمة بشكل بطاقات
            _buildProfileCard([
              _buildProfileItem(context, Icons.edit_note, "Edit profile information", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()))),
              _buildProfileItem(context, Icons.notifications_none, "Notifications", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())), trailing: "ON"),
              _buildProfileItem(context, Icons.translate, "Language", () {}, trailing: "English"),
            ]),
            _buildProfileCard([
              _buildProfileItem(context, Icons.security, "Security", () {}),
              _buildProfileItem(context, Icons.privacy_tip_outlined, "Privacy", () {}),
            ]),
            _buildProfileCard([
              _buildProfileItem(context, Icons.help_outline, "Help & Support", () {}),
              _buildProfileItem(context, Icons.contact_support_outlined, "Contact us", () {}),
              _buildProfileItem(context, Icons.lock_outline, "Privacy policy", () {}),
            ]),
            const SizedBox(height: 100), // مساحة للـ Bottom Bar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(List<Widget> children) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
    child: Column(children: children),
  );

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {String? trailing}) => ListTile(
    leading: Icon(icon, color: const Color(0xFF1B3A4B)),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    trailing: Text(trailing ?? "", style: const TextStyle(color: Colors.blue)),
    onTap: onTap,
  );
}