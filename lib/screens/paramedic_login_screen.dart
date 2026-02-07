import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/contact_admin_screen.dart';
// استيراد الصفحة الجديدة للربط
import 'package:smart_hospital/screens/emergency_case_screen.dart';

class ParamedicLoginScreen extends StatelessWidget {
  const ParamedicLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // استدعاء الخلفية الموحدة
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black)),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text('Paramedic Log in', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  ),
                  const SizedBox(height: 60),
                  const Text('Paramedic ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your ID',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1B3A4B)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // زر تسجيل الدخول الذي ينقلك لصفحة الطوارئ
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmergencyCaseScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      minimumSize: const Size(double.infinity, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),

                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an Id ? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactAdminScreen()));
                            },
                            child: const Text("Contact Admin", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}