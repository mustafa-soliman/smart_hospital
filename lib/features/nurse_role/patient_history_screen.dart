import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientHistoryScreen extends StatelessWidget {
  final String patientName;
  final String roomNumber;

  const PatientHistoryScreen({
    super.key,
    required this.patientName,
    required this.roomNumber,
  });

  @override
  Widget build(BuildContext context) {
    return _PatientHistoryScreenContent(
      patientName: patientName,
      roomNumber: roomNumber,
    );
  }
}

class _PatientHistoryScreenContent extends StatefulWidget {
  final String patientName;
  final String roomNumber;

  const _PatientHistoryScreenContent({
    required this.patientName,
    required this.roomNumber,
  });

  @override
  State<_PatientHistoryScreenContent> createState() => _PatientHistoryScreenContentState();
}

class _PatientHistoryScreenContentState extends State<_PatientHistoryScreenContent> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _inputNoteController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  List<Map<String, dynamic>> _liveTimeline = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientMedicalHistory();
  }

  @override
  void dispose() {
    _inputNoteController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatientMedicalHistory() async {
    try {
      final profileRes = await _supabase
          .from('profiles')
          .select('id')
          .eq('full_name', widget.patientName)
          .maybeSingle();

      if (profileRes != null) {
        final patientData = await _supabase
            .from('patients')
            .select('id')
            .eq('user_id', profileRes['id'])
            .maybeSingle();

        if (patientData != null) {
          final records = await _supabase
              .from('medical_records')
              .select('*')
              .eq('patient_id', patientData['id'])
              .order('created_at', ascending: false);

          List<Map<String, dynamic>> temporaryTimeline = [];

          for (var record in records) {
            final DateTime createdAt = DateTime.parse(record['created_at'].toString());
            final String timeStr = "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

            temporaryTimeline.add({
              'type': record['treatment'] != null && record['treatment'].toString().contains('intervention') ? 'alert' : 'note',
              'title': record['treatment'] != null && record['treatment'].toString().contains('intervention') ? 'Alert Resolved' : 'Clinical Entry',
              'time': timeStr,
              'description': record['diagnosis'] ?? 'No description provided.',
              'icon': record['treatment'] != null && record['treatment'].toString().contains('intervention') ? Icons.warning_amber_rounded : Icons.description_outlined,
              'iconColor': record['treatment'] != null && record['treatment'].toString().contains('intervention') ? const Color(0xFFE05858) : const Color(0xFF475569),
              'iconBg': record['treatment'] != null && record['treatment'].toString().contains('intervention') ? const Color(0xFFFDEBEB) : const Color(0xFFE2E8F0),
            });
          }

          if (temporaryTimeline.isEmpty) {
            temporaryTimeline = _buildFallbackStaticTimeline();
          }

          if (mounted) {
            setState(() {
              _liveTimeline = temporaryTimeline;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _liveTimeline = _buildFallbackStaticTimeline();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading history: $e");
      if (mounted) {
        setState(() {
          _liveTimeline = _buildFallbackStaticTimeline();
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _buildFallbackStaticTimeline() {
    return [
      {
        'type': 'vitals',
        'title': 'Vitals Update',
        'time': '09:45 AM',
        'description': 'Vitals stable. BP: 120/80, HR: 72 bpm.',
        'temp': '98.6°F',
        'spo2': '98%',
        'icon': Icons.analytics_rounded,
        'iconColor': Colors.white,
        'iconBg': const Color(0xFF007AFF),
      },
      {
        'type': 'note',
        'title': 'Nurse Note',
        'time': '08:30 AM',
        'description': 'Patient resting comfortably after morning medication. Reports no pain. Responding well to verbal cues.',
        'icon': Icons.description_outlined,
        'iconColor': const Color(0xFF475569),
        'iconBg': const Color(0xFFE2E8F0),
      },
      {
        'type': 'medication',
        'title': 'Medication Given',
        'time': '08:00 AM',
        'description': 'Administered 500mg Paracetamol',
        'subtext': 'Verified by Nurse J. Simmons',
        'icon': Icons.medical_services_outlined,
        'iconColor': const Color(0xFF007AFF),
        'iconBg': const Color(0xFFE3F2FD),
      },
      {
        'type': 'alert',
        'title': 'Previous Alert',
        'time': '06:15 AM',
        'description': 'Critical Alert: Heart rate spike detected (142 bpm). Resolved by Dr. Thorne',
        'icon': Icons.warning_amber_rounded,
        'iconColor': const Color(0xFFE05858),
        'iconBg': const Color(0xFFFDEBEB),
      },
    ];
  }

  Future<void> _saveManualNurseEntry() async {
    if (_inputNoteController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final profileRes = await _supabase
          .from('profiles')
          .select('id')
          .eq('full_name', widget.patientName)
          .maybeSingle();

      if (profileRes != null) {
        final patientData = await _supabase
            .from('patients')
            .select('id')
            .eq('user_id', profileRes['id'])
            .maybeSingle();

        if (patientData != null) {
          await _supabase.from('medical_records').insert({
            'patient_id': patientData['id'],
            'diagnosis': 'Nurse Entry: ${_inputNoteController.text.trim()}',
            'treatment': 'Routine Nurse Care Record',
          });

          _inputNoteController.clear();
          if (mounted) {
            Navigator.pop(context);
            _fetchPatientMedicalHistory();
          }
        }
      }
    } catch (e) {
      debugPrint("Error saving manual entry: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showAddNoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add New Note / Record',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17)),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _inputNoteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Type patient observations, clinical notes or vitals update...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveManualNurseEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Record', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
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
        title: const Text(
          'Patient History',
          style: TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF007AFF)))
            : Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
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
                        Text(
                          widget.patientName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Room ${widget.roomNumber} • ID: #8829-X',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildHeaderBadge('STABLE', const Color(0xFFE3F2FD), const Color(0xFF007AFF)),
                            const SizedBox(width: 8),
                            _buildHeaderBadge('POST-OP DAY 2', const Color(0xFFFFEFE6), const Color(0xFFC96A1F)),
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
                itemCount: _liveTimeline.length,
                itemBuilder: (context, index) {
                  final item = _liveTimeline[index];
                  return Stack(
                    children: [
                      if (index != _liveTimeline.length - 1)
                        Positioned(
                          top: 40,
                          left: 23,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: item['iconBg'],
                                shape: BoxShape.circle,
                                boxShadow: item['type'] == 'vitals'
                                    ? [
                                  BoxShadow(
                                    color: const Color(0xFF007AFF).withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                                    : null,
                              ),
                              child: Icon(item['icon'], color: item['iconColor'], size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F0F17)),
                                      ),
                                      Text(
                                        item['time'],
                                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: item['type'] == 'alert'
                                          ? const Color(0xFFFDEBEB).withValues(alpha: 0.5)
                                          : (item['type'] == 'medication' ? Colors.white : const Color(0xFFF8FAFC)),
                                      borderRadius: BorderRadius.circular(20),
                                      border: item['type'] == 'medication'
                                          ? const Border(left: BorderSide(color: Color(0xFF0056B3), width: 4))
                                          : Border.all(color: const Color(0xFFF1F5F9), width: 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['description'],
                                          style: TextStyle(
                                            color: item['type'] == 'alert' ? const Color(0xFFE05858) : const Color(0xFF334155),
                                            fontSize: 14,
                                            height: 1.4,
                                            fontWeight: item['type'] == 'alert' ? FontWeight.w600 : FontWeight.w500,
                                          ),
                                        ),
                                        if (item['type'] == 'vitals') ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: const Color(0xFFE2E8F0),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              _buildVitalMetric('TEMP', item['temp'] ?? '98.6°F'),
                                              const SizedBox(width: 24),
                                              _buildVitalMetric('SPO2', item['spo2'] ?? '98%'),
                                            ],
                                          )
                                        ],
                                        if (item['type'] == 'medication' && item['subtext'] != null) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            item['subtext'],
                                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontStyle: FontStyle.italic),
                                          )
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomPaint(
                painter: _DashedRectPainter(color: const Color(0xFFCBD5E1)),
                child: TextButton(
                  onPressed: _showAddNoteBottomSheet,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Color(0xFF475569), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Add Manual Entry',
                        style: TextStyle(color: Color(0xFF475569), fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(String text, Color bg, Color textColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: textColors, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  Widget _buildVitalMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );

    final path = Path();
    path.addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth > metric.length) ? metric.length - distance : dashWidth;
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}