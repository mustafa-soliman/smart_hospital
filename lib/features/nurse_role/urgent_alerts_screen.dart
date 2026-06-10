import 'package:flutter/material.dart';
import 'alert_details_screen.dart';

class UrgentAlertsScreen extends StatefulWidget {
  const UrgentAlertsScreen({super.key});

  @override
  State<UrgentAlertsScreen> createState() => _UrgentAlertsScreenState();
}

class _UrgentAlertsScreenState extends State<UrgentAlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': '1',
      'name': 'Sara Ahmed',
      'roomNumber': 'ROOM 402',
      'roomTime': 'Room 402 • 10:15 AM',
      'vitalTitle': 'High Heart Rate',
      'value': '142',
      'unit': 'BPM',
      'status': 'CRITICAL',
      'isCritical': true,
      'icon': Icons.favorite_rounded,
      'iconColor': const Color(0xFFE05858),
      'iconBg': const Color(0xFFFDEBEB),
    },
    {
      'id': '2',
      'name': 'Ola Ali',
      'roomNumber': 'ROOM 315',
      'roomTime': 'Room 315 • 10:08 AM',
      'vitalTitle': 'Low O2 Saturation',
      'value': '91',
      'unit': '%',
      'status': 'NEEDS ATTENTION',
      'isCritical': false,
      'icon': Icons.air_rounded,
      'iconColor': const Color(0xFFC96A1F),
      'iconBg': const Color(0xFFFEF5E6),
    },
    {
      'id': '3',
      'name': 'Ragab Reda',
      'roomNumber': 'ROOM 408',
      'roomTime': 'Room 408 • 09:55 AM',
      'vitalTitle': 'Elevated Temperature',
      'value': '103.4',
      'unit': '°F',
      'status': 'CRITICAL',
      'isCritical': true,
      'icon': Icons.thermostat_rounded,
      'iconColor': const Color(0xFFE05858),
      'iconBg': const Color(0xFFFDEBEB),
    },
    {
      'id': '4',
      'name': 'Amer Omar',
      'roomNumber': 'ROOM 212',
      'roomTime': 'Room 212 • 09:42 AM',
      'vitalTitle': 'Elevated BP',
      'value': '158/94',
      'unit': 'mmHg',
      'status': 'NEEDS ATTENTION',
      'isCritical': false,
      'icon': Icons.analytics_rounded,
      'iconColor': const Color(0xFFC96A1F),
      'iconBg': const Color(0xFFFEF5E6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Urgent Alerts',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEBEB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Color(0xFFE05858), size: 24),
                          SizedBox(height: 8),
                          Text(
                            '03',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFE05858)),
                          ),
                          Text(
                            'Critical Issues',
                            style: TextStyle(fontSize: 12, color: Color(0xFFE05858), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications_none_rounded, color: Color(0xFF1E293B), size: 24),
                          SizedBox(height: 8),
                          Text(
                            '12',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                          Text(
                            'Attention Needed',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    final bool isCritical = alert['isCritical'];
                    final Color mainTextColor = isCritical ? const Color(0xFFE05858) : const Color(0xFFC96A1F);
                    final Color badgeBg = isCritical ? const Color(0xFFE05858) : const Color(0xFFC96A1F);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlertDetailsScreen(
                              patientName: alert['name'],
                              roomNumber: alert['roomNumber'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Color(0xFFF1F5F9),
                                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alert['name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        alert['roomTime'],
                                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    alert['status'],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.3),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    alert['vitalTitle'],
                                    style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        alert['value'],
                                        style: TextStyle(color: mainTextColor, fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        alert['unit'],
                                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}