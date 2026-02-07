import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/paramedic_login_screen.dart'; // صفحة دخول المسعف
import 'package:smart_hospital/screens/onboarding_screen.dart';      // صفحة التعريف للكل

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. الخلفية الموحدة للمشروع
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.white);
            },
          ),

          // 2. طبقة تفتيح شفافة
          Container(
            color: Colors.white.withOpacity(0.4),
          ),

          // 3. المحتوى الرئيسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select Your Role',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // قائمة الأزرار
                  _buildRoleButton(
                    context,
                    roleName: 'Doctor',
                    emoji: '👨‍⚕️',
                    onTap: () => _goToOnboarding(context),
                  ),
                  _buildRoleButton(
                    context,
                    roleName: 'Nurse',
                    emoji: '👩‍⚕️',
                    onTap: () => _goToOnboarding(context),
                  ),
                  _buildRoleButton(
                    context,
                    roleName: 'Paramedic',
                    emoji: '🚑',
                    onTap: () {
                      // المسعف ينتقل مباشرة لصفحة تسجيل الدخول الخاصة به
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ParamedicLoginScreen()),
                      );
                    },
                  ),
                  _buildRoleButton(
                    context,
                    roleName: 'Patient',
                    emoji: '🤒',
                    onTap: () => _goToOnboarding(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // الدالة المصححة للانتقال لصفحة الـ Onboarding الاحترافية
  void _goToOnboarding(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  // ويدجت بناء الزر بتصميم الكبسولة (StadiumBorder)
  Widget _buildRoleButton(
      BuildContext context, {
        required String roleName,
        required String emoji,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B3A4B),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 65),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(width: 15),
            Text(
              roleName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}