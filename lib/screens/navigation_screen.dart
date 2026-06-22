import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'case_completed_screen.dart';
import 'case_rejected_screen.dart';

class NavigationScreen extends StatefulWidget {
  final String caseId;

  const NavigationScreen({
    super.key,
    required this.caseId,
  });

  static int visitCount = 0;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  @override
  void initState() {
    super.initState();
    _startStaticTimer();
  }

  void _startStaticTimer() {
    NavigationScreen.visitCount++;

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        if (NavigationScreen.visitCount == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CaseRejectedScreen(caseId: widget.caseId)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CaseCompletedScreen()),
          );
        }
      }
    });
  }

  Future<void> _openGoogleMaps() async {
    final String googleMapsUrl = "google.navigation:q=30.0444,31.2357&mode=d";
    final Uri url = Uri.parse(googleMapsUrl);
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
          Image.asset(
            'assets/images/map_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE5E5E5),
                child: const Center(
                  child: Icon(Icons.map_outlined, size: 100, color: Colors.grey),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Navigation',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFF0D638F),
                    child: Icon(Icons.navigation, color: Colors.white, size: 35),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.radio_button_checked, color: Color(0xFF1B3A4B), size: 22),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey[400],
                              ),
                              const Icon(Icons.location_on, color: Colors.red, size: 24),
                            ],
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PICKUP', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('My current location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1B3A4B))),
                                SizedBox(height: 25),
                                Text('DROP-OFF', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('SHH Hospital', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Arrival Time', style: TextStyle(fontSize: 16, color: Color(0xFF1B3A4B), fontWeight: FontWeight.w500)),
                          Text('3 min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _openGoogleMaps,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3A4B),
                          minimumSize: const Size(double.infinity, 60),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Start Navigation in GPS',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}