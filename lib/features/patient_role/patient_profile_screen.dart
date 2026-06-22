import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/screens/role_selection_screen.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'settings_screen.dart';
import 'favorite_doctors_screen.dart';
import 'widgets/custom_popups.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String _patientName = 'Patient';
  String _patientEmail = '';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchPatientProfileData();
  }

  // جلب بيانات بروفايل المريض الحقيقية لايف من السيرفر
  Future<void> _fetchPatientProfileData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        _patientEmail = user.email ?? '';

        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (data != null) {
          setState(() {
            _patientName = data['full_name'] ?? 'Patient';
            _avatarUrl = data['avatar_url'];
            _isLoading = false;
          });
          return;
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Error loading patient profile: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
          : SingleChildScrollView(
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
                          backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty
                              ? NetworkImage(_avatarUrl!)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: const Color(0xFF1A394A),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              onPressed: () {
                                // يمكن إضافة لوجيك رفع الصورة هنا لاحقاً
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _patientName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _patientEmail,
                      style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // خيارات القائمة المربوطة بصفحاتك الحقيقية
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
                icon: Icons.favorite_border,
                title: 'Favorite Doctors',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteDoctorsScreen()),
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
              const SizedBox(height: 30),

              // زر تسجيل الخروج الآمن المربوط بالـ PopUp بتاعك
              _buildMenuOption(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  CustomPopups.showLogoutPopup(
                    context,
                    onConfirm: () async {
                      await _supabase.auth.signOut();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                            (route) => false,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
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
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A394A).withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1A394A), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A394A))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      ),
    );
  }
}