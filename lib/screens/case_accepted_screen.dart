import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/navigation_screen.dart';

class CaseAcceptedScreen extends StatelessWidget {
  final String bedNumber;
  final String floor;
  final String department;
  final String hospitalName;
  final String caseId;

  const CaseAcceptedScreen({
    super.key,
    required this.bedNumber,
    required this.floor,
    required this.department,
    required this.hospitalName,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                  const Center(
                    child: Text(
                      'Case Accepted',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF0D638F),
                      child: Icon(Icons.check, color: Colors.white, size: 55),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'A bed has been reserved for this patient',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B3A4B)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Bed Number', bedNumber),
                        const SizedBox(height: 15),
                        _buildInfoRow('Floor', floor),
                        const SizedBox(height: 15),
                        _buildInfoRow('Department', department),
                        const SizedBox(height: 15),
                        _buildInfoRow('Hospital', hospitalName),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavigationScreen(caseId: caseId)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3A4B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Color(0xFF1B3A4B), fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
        ),
      ],
    );
  }
}