import 'package:flutter/material.dart';
// استيراد صفحة الملاحة لربطها بالزر
import 'package:smart_hospital/screens/navigation_screen.dart';

class TransferCompletedScreen extends StatelessWidget {
  const TransferCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية الموحدة للمشروع
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.white.withOpacity(0.4)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),

                const Spacer(flex: 1),

                // أيقونة النجاح المعتمدة في التصميم
                _buildSuccessIcon(),

                const SizedBox(height: 40),

                // نص التأكيد الموضح في صورتك
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'The case has been successfully redirected to Hospital A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B3A4B),
                      height: 1.4,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // زر الانتقال إلى صفحة الملاحة (Navigation)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // الربط المطلوب: الانتقال لصفحة Navigation التي تم إنشاؤها سابقاً
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
            ),
          ),
          const Expanded(
            child: Text(
              'Transfer Completed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3A4B),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF0D638F),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 60),
    );
  }
}