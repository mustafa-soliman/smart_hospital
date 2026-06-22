import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/sign_in_screen.dart';

class LogoutDialog extends StatelessWidget {
  final String userRole;

  const LogoutDialog({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: const Color(0xFFEDF1F3), borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Logout",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
            ),
            const SizedBox(height: 15),
            const Text(
              "are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF5E7A8D)),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Color(0xFF94A3B8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen(userRole: userRole)),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3A4B),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Yes, Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}