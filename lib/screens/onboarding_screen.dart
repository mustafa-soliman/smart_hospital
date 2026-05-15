import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String userRole;
  const OnboardingScreen({super.key, required this.userRole});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to Smart Hospital",
      "desc": "Your health in your hands manage appointments, view reports, and get instant alerts",
      "image": "assets/images/doctor_onboarding.png"
    },
    {
      "title": "Smart Care & Quick Access",
      "desc": "Book appointments, track your medical records, and receive nurse alerts instantly",
      "image": "assets/images/care_onboarding.png"
    },
    {
      "title": "Smart Connect",
      "desc": "Our smart system connects doctors, nurses, and patients, safely and efficiently",
      "image": "assets/images/connect_onboarding.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ClipPath(
                    clipper: OnboardingClipper(),
                    child: Image.asset(
                      _onboardingData[index]['image']!,
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(_onboardingData[index]['title']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                        const SizedBox(height: 15),
                        Text(_onboardingData[index]['desc']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(onPressed: _navigateToSignIn, child: const Text('Skip', style: TextStyle(color: Colors.grey, fontSize: 16))),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_onboardingData.length, (index) => _buildDot(index == _currentPage))),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _onboardingData.length - 1) {
                      _navigateToSignIn();
                    } else {
                      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3A4B), minimumSize: const Size(double.infinity, 60), shape: const StadiumBorder()),
                  child: Text(_currentPage == _onboardingData.length - 1 ? "Let's Get Started" : "Next", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen(userRole: widget.userRole)));
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4), height: 8, width: isActive ? 20 : 8, decoration: BoxDecoration(color: isActive ? const Color(0xFF1B3A4B) : Colors.grey[300], borderRadius: BorderRadius.circular(4)));
  }
}

class OnboardingClipper extends CustomClipper<Path> {
  @override Path getClip(Size size) { Path path = Path(); path.lineTo(0, size.height - 80); path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80); path.lineTo(size.width, 0); path.close(); return path; }
  @override bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}