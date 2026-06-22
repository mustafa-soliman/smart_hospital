import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/nearby_hospital_screen.dart';

class CaseRejectedScreen extends StatelessWidget {
  final String caseId;

  const CaseRejectedScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Case Rejected',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD32F2F).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xFFD32F2F),
                          child: Icon(Icons.close, color: Colors.white, size: 45),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'The hospital cannot receive this patient',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No available beds at SHH Hospital',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1B3A4B),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NearbyHospitalScreen(caseId: caseId),
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
                      'Suggest Nearby Hospitals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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