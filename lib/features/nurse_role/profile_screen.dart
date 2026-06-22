import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'logout_dialog.dart';
import 'password_manager_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _isLoading = true;
  Map<String, dynamic>? _nurseProfile;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchNurseData();
  }

  // جلب بيانات الممرضة الحقيقية لايف لعرضها في البروفايل
  Future<void> _fetchNurseData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        setState(() {
          _nurseProfile = data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching nurse profile in screen: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF132530))),
      );
    }

    // قراءة البيانات المجلوبة أو وضع قيم افتراضية لو مش موجودة
    final String nurseName = _nurseProfile?['full_name'] ?? 'Nurse';
    final String nurseEmail = _supabase.auth.currentUser?.email ?? 'nurse@hospital.com';
    final String? avatarUrl = _nurseProfile?['avatar_url'];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'My Profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF132530)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFFF1F5F9),
                          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // الانتقال لتعديل البروفايل وتمرير البيانات الحقيقية
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  initialData: EditProfileModel(
                                    name: nurseName,
                                    email: nurseEmail,
                                    phoneNumber: _nurseProfile?['phone_number'] ?? '',
                                    dateOfBirth: _nurseProfile?['date_of_birth'] ?? '',
                                    imageUrl: avatarUrl,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF132530),
                            child: Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    nurseName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'GENERAL',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                _buildMenuSwitchTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const SizedBox(height: 12),
                _buildMenuNavigationTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailingText: 'English',
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                const Text(
                  'SECURITY',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                _buildMenuNavigationTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(
                          data: PrivacyPolicyModel(
                            lastUpdate: 'June 2026',
                            privacyParagraphs: ['We value your privacy and protect your personal hospital data.'],
                            termsConditions: ['Use the application according to the hospital guidelines.'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMenuNavigationTile(
                  icon: Icons.lock_open_rounded,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordManagerScreen()));
                  },
                ),
                const SizedBox(height: 40),

                // زرار الـ Logout المربوط بالـ Dialog اللي إنت عامله
                GestureDetector(
                  onTap: () => LogoutDialog.show(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFFFFEAEA), borderRadius: BorderRadius.circular(24)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: Color(0xFFE05858), size: 20),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Color(0xFFE05858), fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF64748B), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A)))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF132530),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuNavigationTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF64748B), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF0F172A)))),
            if (trailingText != null) Text(trailingText, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 16),
          ],
        ),
      ),
    );
  }
}