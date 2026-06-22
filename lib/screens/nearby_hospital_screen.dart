import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/confirm_transfer_popup.dart';

class NearbyHospitalScreen extends StatelessWidget {
  final String caseId;

  const NearbyHospitalScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFD2E3EB)),
          ),
          Container(
            color: Colors.white.withOpacity(0.15),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1B3A4B)),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Nearby Hospital',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B3A4B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0D638F).withOpacity(0.2),
                    ),
                    child: Center(
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0D638F),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    children: [
                      _buildHospitalCard(context, 'Hospital A', '1.5 km', '3', '5 min'),
                      const SizedBox(height: 20),
                      _buildHospitalCard(context, 'Hospital B', '2.5 km', '1', '9 min'),
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

  Widget _buildHospitalCard(BuildContext context, String name, String distance, String beds, String eta) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A4B),
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoRow('Distance', distance),
          _buildInfoRow('Beds', beds),
          _buildInfoRow('ETA', eta),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmTransferPopup(caseId: caseId),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: const Text(
                'Select',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1B3A4B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1B3A4B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}