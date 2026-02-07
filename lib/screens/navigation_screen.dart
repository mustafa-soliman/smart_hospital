import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  
import 'case_completed_screen.dart';
import 'case_rejected_screen.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  Future<void> _launchGPS() async {
    const String lat = "30.0444";
    const String lng = "31.2357";
    final Uri url = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Navigation',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: _launchGPS,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, size: 100, color: Color(0xFF1B3A4B)),
                            SizedBox(height: 10),
                            Text('Tap to view route on GPS', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر حالة النجاح (Case Completed)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseCompletedScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 55),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Case Completed (Success)',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 15),

          // زر حالة الرفض (Case Rejected)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseRejectedScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 55),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Case Rejected (Failed)',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}