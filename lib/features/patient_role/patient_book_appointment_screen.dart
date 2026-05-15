import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/patient_review_appointment_screen.dart';

class PatientBookAppointmentScreen extends StatefulWidget {
  const PatientBookAppointmentScreen({super.key});

  @override
  State<PatientBookAppointmentScreen> createState() => _PatientBookAppointmentScreenState();
}

class _PatientBookAppointmentScreenState extends State<PatientBookAppointmentScreen> {
  int selectedDateIndex = 2;
  int selectedTimeIndex = 0;

  final List<Map<String, String>> dates = [
    {'day': 'Sun', 'date': '3'},
    {'day': 'Mon', 'date': '4'},
    {'day': 'Tue', 'date': '5'},
    {'day': 'Wed', 'date': '6'},
    {'day': 'Thu', 'date': '7'},
  ];

  final List<String> times = ['9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Book Appointment', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDoctorHeader(),
            _buildAppointmentSection(),
            _buildTimeSection(),
            const SizedBox(height: 30),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset('assets/images/default_avatar.png', width: double.infinity, height: 300, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Hamza Ahmed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Cardiologist and Surgeon', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text('4.9 (96 reviews)', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedDateIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedDateIndex = index),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF81D4FA) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dates[index]['day']!, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                      Text(dates[index]['date']!, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Available Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            children: List.generate(times.length, (index) {
              bool isSelected = selectedTimeIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedTimeIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFCC80) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Text(times[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientReviewAppointmentScreen())),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A394A),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}