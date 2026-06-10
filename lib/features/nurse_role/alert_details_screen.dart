// File: lib/features/nurse_role/alert_details_screen.dart

import 'package:flutter/material.dart';

class AlertDetailsScreen extends StatefulWidget {
  final String patientName;
  final String roomNumber;

  const AlertDetailsScreen({
    super.key,
    required this.patientName,
    required this.roomNumber,
  });

  @override
  State<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();

  // 1. اللوجيك الخاص بإظهار الـ Toast العلوي الناجح تبيكال زي الصورة الثانية
  void _showSuccessOverlay() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // شفافة تماماً عشان تظهر فوق الشاشة الأصلية
      builder: (BuildContext context) {
        // غلق التوست تلقائياً بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });

        return Stack(
          children: [
            Positioned(
              top: 50, // التموضع العلوي تبيكال زي الصورة
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
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F8EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: Color(0xFF53C07F), size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Resolve Alert successfully',
                          style: TextStyle(
                            color: Color(0xFF0F0F17),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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

  // 2. اللوجيك الخاص بالـ BottomSheet تبيكال نفس تصميم الصورة الأولى
  void _showResolutionBottomSheet() {
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 16,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الـ Notch العلوي الرمادي الصغير
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Resolution Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F0F17),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Observation Note',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // حقل إدخال الملاحظات تبيكال بنفس درجات ألوان الفيجما المرفوعة
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF0F0F17)),
                  decoration: const InputDecoration(
                    hintText: 'Describe the clinical action taken...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // زر الـ Resolve Alert جاهز لربط مخرجات الـ Controller بالباك اند
              ElevatedButton(
                onPressed: () {
                  // هنا بمجرد الربط بتمرر الـ _noteController.text للـ API بتاعك
                  Navigator.pop(context); // غلق الـ BottomSheet
                  _showSuccessOverlay(); // إظهار توست النجاح العلوي
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3546), // نفس درجة الكحلي الغامق بالظبط
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text(
                  'Resolve Alert',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
          'Alert Details',
          style: TextStyle(color: Color(0xFF0F0F17), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDEBEB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'CRITICAL ALERT',
                            style: TextStyle(color: Color(0xFFE05858), fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                        const Text(
                          'Updated 2m ago',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.patientName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.roomNumber} — Post-Op Recovery',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildMiniInfoBox('BEDSIDE', widget.roomNumber.replaceAll('ROOM ', 'Bedside ')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ADMITTED', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('14 Oct, 10.15', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F0F17))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Live Vitals',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEBEB).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFFDEBEB), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, color: Color(0xFFE05858), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HEART RATE', style: TextStyle(color: Color(0xFFE05858), fontSize: 11, fontWeight: FontWeight.bold)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const [
                            Text('142', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
                            SizedBox(width: 4),
                            Text('BPM', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        return Container(
                          width: 4,
                          height: (index == 0 || index == 4) ? 14.0 : (index == 2 ? 28.0 : 22.0),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE05858), borderRadius: BorderRadius.circular(2)),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSmallVitalCard('SPO2', '91%', 'Attention Needed', Icons.air, const Color(0xFFC96A1F), const Color(0xFFFEF5E6)),
                  const SizedBox(width: 16),
                  _buildSmallVitalCard('TEMP', '98.6°F', 'Within Range', Icons.thermostat, const Color(0xFF007AFF), const Color(0xFFE3F2FD)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.psychology_outlined, color: Color(0xFF007AFF)),
                        SizedBox(width: 10),
                        Text('Alert Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F0F17))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Color(0xFF475569), fontSize: 14, height: 1.5),
                        children: [
                          TextSpan(text: 'Persistent tachycardia detected over the last 15 minutes. Patient reports '),
                          TextSpan(text: 'slight chest discomfort', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
                          TextSpan(text: '. Immediate physical assessment recommended.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // تم ربط الزر السفلي بالـ BottomSheet التبيكال أهو
              ElevatedButton(
                onPressed: _showResolutionBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3546),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Update State', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfoBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F0F17))),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallVitalCard(String label, String value, String status, IconData icon, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F0F17))),
            const SizedBox(height: 4),
            Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}