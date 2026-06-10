import 'package:flutter/material.dart';

class MedicationScreen extends StatefulWidget {
  final String patientName;
  final String roomNumber;

  const MedicationScreen({
    super.key,
    required this.patientName,
    required this.roomNumber,
  });

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final _medNameController = TextEditingController();
  String _selectedDosage = '5mg';

  final List<Map<String, dynamic>> _medications = [
    {
      'id': '1',
      'name': 'Paracetamol',
      'details': '500mg • Oral Tablet',
      'status': 'DUE',
      'schedule': 'Next Dose: 08:00 AM',
      'icon': Icons.local_hospital_rounded,
      'color': const Color(0xFF007AFF),
      'bg': const Color(0xFFE3F2FD),
    },
    {
      'id': '2',
      'name': 'Amiodarone',
      'details': '150mg • IV Bolus',
      'status': 'GIVEN',
      'schedule': 'Administered at 07:15 AM',
      'icon': Icons.vaccines_rounded,
      'color': const Color(0xFF53C07F),
      'bg': const Color(0xFFE8F8EE),
    },
    {
      'id': '3',
      'name': 'Lisinopril',
      'details': '10mg • Oral Capsule',
      'status': 'DUE',
      'schedule': 'Next Dose: 12:00 PM',
      'icon': Icons.medication_liquid_rounded,
      'color': const Color(0xFF007AFF),
      'bg': const Color(0xFFE3F2FD),
    },
    {
      'id': '4',
      'name': 'Metformin',
      'details': '500mg • Oral Tablet',
      'status': 'SKIPPED',
      'schedule': 'Refused by patient at 06:00 AM',
      'icon': Icons.block_rounded,
      'color': const Color(0xFF94A3B8),
      'bg': const Color(0xFFF1F5F9),
    },
  ];

  void _showStatusToast(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });
        return Stack(
          children: [
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFE8F8EE), shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, color: Color(0xFF53C07F), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message, style: const TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 14)),
                            const Text('History updated in real-time', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 16),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddMedicationPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Quick Add Medication', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
              const SizedBox(height: 4),
              const Text('Enter details for the next dose', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('MEDICATION NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007AFF))),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                child: TextFormField(
                  controller: _medNameController,
                  decoration: const InputDecoration(hintText: 'e.g. Insulin', hintStyle: TextStyle(color: Color(0xFFCBD5E1)), border: InputBorder.none, contentPadding: EdgeInsets.all(14)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('DOSAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007AFF))),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDosage,
                              isExpanded: true,
                              items: ['5mg', '10mg', '500mg'].map((String val) {
                                return DropdownMenuItem<String>(value: val, child: Text(val));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedDosage = value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TIME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007AFF))),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                          child: const Row(
                            children: [
                              Icon(Icons.access_time_filled, color: Color(0xFF007AFF), size: 18),
                              SizedBox(width: 6),
                              Text('08:00 AM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showStatusToast('Medication added successfully');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007AFF), minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0),
                child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'DUE') return const Color(0xFF007AFF);
    if (status == 'GIVEN') return const Color(0xFF53C07F);
    return const Color(0xFF94A3B8);
  }

  Color _getStatusBg(String status) {
    if (status == 'DUE') return const Color(0xFFE3F2FD);
    if (status == 'GIVEN') return const Color(0xFFE8F8EE);
    return const Color(0xFFF1F5F9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F0F17), size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text('Medication', style: TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationPopup,
        backgroundColor: const Color(0xFF007AFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Image(
                    image: AssetImage('assets/images/default_avatar.png'),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.patientName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
                      const SizedBox(height: 4),
                      Text('${widget.roomNumber} • ID: #8829-X', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)), child: const Text('STABLE', style: TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold, fontSize: 10))),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFEFE6), borderRadius: BorderRadius.circular(8)), child: const Text('POST-OP DAY 2', style: TextStyle(color: Color(0xFFC96A1F), fontWeight: FontWeight.bold, fontSize: 10))),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final med = _medications[index];
                final String status = med['status'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: med['bg'], borderRadius: BorderRadius.circular(14)), child: Icon(med['icon'], color: med['color'], size: 24)),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(med['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F0F17))),
                              const SizedBox(height: 2),
                              Text(med['details'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: _getStatusBg(status), borderRadius: BorderRadius.circular(8)),
                            child: Text(status, style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold, fontSize: 10)),
                          )
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF94A3B8), size: 16),
                          const SizedBox(width: 6),
                          Text(med['schedule'], style: TextStyle(color: status == 'GIVEN' ? const Color(0xFF53C07F) : (status == 'SKIPPED' ? const Color(0xFF94A3B8) : const Color(0xFF334155)), fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (status == 'DUE') ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showStatusToast('Status updated successfully'),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0056B3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0, minimumSize: const Size(0, 48)),
                                child: const Text('Mark as Given', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0, minimumSize: const Size(0, 48)),
                                child: const Text('Skip', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}