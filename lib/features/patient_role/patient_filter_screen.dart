import 'package:flutter/material.dart';

class PatientFilterScreen extends StatefulWidget {
  const PatientFilterScreen({super.key});

  @override
  State<PatientFilterScreen> createState() => _PatientFilterScreenState();
}

class _PatientFilterScreenState extends State<PatientFilterScreen> {
  RangeValues _priceRange = const RangeValues(200, 350);
  int _selectedRating = 4;

  final List<Map<String, dynamic>> _specializations = [
    {'name': 'All', 'isSelected': true},
    {'name': 'Cardiologist', 'isSelected': false},
    {'name': 'Dentist', 'isSelected': false},
    {'name': 'Neurologist', 'isSelected': true},
    {'name': 'Orthopedic', 'isSelected': false},
    {'name': 'Dermatologist', 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Filter',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Reset', style: TextStyle(color: Color(0xFF0061C4), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
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
                  const Text(
                    'Specialization',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _specializations.map((spec) => _buildFilterChip(spec['name'], spec['isSelected'])).toList(),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_priceRange.start.round()}-${_priceRange.end.round()}EGP',
                          style: const TextStyle(color: Color(0xFF0061C4), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RangeSlider(
                    values: _priceRange,
                    max: 500,
                    divisions: 10,
                    activeColor: const Color(0xFF0061C4),
                    inactiveColor: const Color(0xFFF1F4F7),
                    onChanged: (values) => setState(() => _priceRange = values),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0EGP', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('500EGP', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) => _buildRatingItem(index + 1)),
                  ),
                  const SizedBox(height: 30),
                  _buildAdviceCard(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRatingItem(int rating) {
    bool isSelected = _selectedRating == rating;
    return GestureDetector(
      onTap: () => setState(() => _selectedRating = rating),
      child: Container(
        width: 60,
        height: 75,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: isSelected ? Colors.white : Colors.black26, size: 24),
            const SizedBox(height: 5),
            Text(
              rating.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HEALTHCARE ADVICE',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Filter by Rating and Price to find the most balanced care for your recovery journey.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.medical_services_outlined, color: Colors.grey.withValues(alpha: 0.2), size: 60),
        ],
      ),
    );
  }
}