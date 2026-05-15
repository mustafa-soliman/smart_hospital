import 'package:flutter/material.dart';

class PatientAmbulanceNavigationScreen extends StatelessWidget {
  const PatientAmbulanceNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // هنا يتم وضع الـ Google Map لاحقاً، حالياً سنضع خلفية رمادية كمحاكاة
          Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.map, size: 100, color: Colors.grey))),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavRow(Icons.my_location, 'My current location', Colors.blue),
                  const Padding(padding: EdgeInsets.only(left: 12), child: SizedBox(height: 20, child: VerticalDivider(thickness: 2))),
                  _buildNavRow(Icons.location_on, 'SHH Hospital', Colors.red),
                  const Divider(height: 40),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Arrival Time', style: TextStyle(color: Colors.grey)), Text('3 min', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A394A), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: const Text('Track Ambulance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavRow(IconData icon, String label, Color color) {
    return Row(children: [Icon(icon, color: color), const SizedBox(width: 15), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]);
  }
}