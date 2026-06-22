import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hospital/features/patient_role/patient_review_appointment_screen.dart';

class PatientBookAppointmentScreen extends StatefulWidget {
  final String doctorId;

  const PatientBookAppointmentScreen({super.key, required this.doctorId});

  @override
  State<PatientBookAppointmentScreen> createState() => _PatientBookAppointmentScreenState();
}

class _PatientBookAppointmentScreenState extends State<PatientBookAppointmentScreen> {
  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  List<Map<String, String>> dates = [];

  final List<String> times = ['9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM'];

  @override
  void initState() {
    super.initState();
    _generateCurrentWeek();
  }

  void _generateCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    List<Map<String, String>> currentWeekDates = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      currentWeekDates.add({
        'day': DateFormat('E').format(day),
        'date': day.day.toString(),
        'fullDate': "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}"
      });
      if (day.day == now.day && day.month == now.month && day.year == now.year) {
        selectedDateIndex = i;
      }
    }

    setState(() {
      dates = currentWeekDates;
    });
  }

  Future<void> _pickCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A394A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A394A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String pickedDateStr = picked.day.toString();
      String pickedDayName = DateFormat('E').format(picked);
      String pickedFullDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      int existingIndex = dates.indexWhere((element) => element['fullDate'] == pickedFullDate);

      setState(() {
        if (existingIndex != -1) {
          selectedDateIndex = existingIndex;
        } else {
          dates.add({
            'day': pickedDayName,
            'date': pickedDateStr,
            'fullDate': pickedFullDate,
          });
          selectedDateIndex = dates.length - 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: Color(0xFF1A394A), size: 22),
            onPressed: _pickCustomDate,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SELECT DATE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 15),
                  _buildDatePicker(),
                  const SizedBox(height: 30),
                  const Text('SELECT TIME', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 15),
                  _buildTimePicker(),
                ],
              ),
            ),
          ),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    if (dates.isEmpty) return const SizedBox(height: 90);
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A394A) : const Color(0xFFF1F4F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dates[index]['day']!, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(dates[index]['date']!, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(times.length, (index) {
        bool isSelected = selectedTimeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => selectedTimeIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFCC80) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Text(
              times[index],
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          if (dates.isEmpty) return;
          String finalDate = dates[selectedDateIndex]['fullDate']!;
          String finalTime = times[selectedTimeIndex];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientReviewAppointmentScreen(
                doctorId: widget.doctorId,
                appointmentDate: finalDate,
                appointmentTime: finalTime,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A394A),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}