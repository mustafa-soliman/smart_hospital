import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'alert_details_screen.dart';

class UrgentAlertsScreen extends StatefulWidget {
  const UrgentAlertsScreen({super.key});

  @override
  State<UrgentAlertsScreen> createState() => _UrgentAlertsScreenState();
}

class _UrgentAlertsScreenState extends State<UrgentAlertsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _alertsList = [];
  int _criticalCount = 0;
  int _attentionCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLiveAlerts();
  }

  Future<void> _fetchLiveAlerts() async {
    try {
      final data = await _supabase
          .from('emergency_cases')
          .select('*')
          .order('created_at', ascending: false);

      int critical = 0;
      int attention = 0;

      for (var item in data) {
        final String status = (item['status'] ?? '').toString().toLowerCase();
        if (status == 'critical' || status == 'pending') {
          critical++;
        } else if (status == 'in_progress') {
          attention++;
        }
      }

      if (mounted) {
        setState(() {
          _alertsList = data;
          _criticalCount = critical;
          _attentionCount = attention;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching urgent alerts: $e");
      if (mounted) setState(() => _isLoading = false);
    }
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
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Urgent Alerts',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF007AFF)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth = (constraints.maxWidth - 14) / 2;
                  return Row(
                    children: [
                      Container(
                        width: itemWidth,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDEBEB),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFE05858), size: 24),
                            const SizedBox(height: 8),
                            Text(
                              _criticalCount.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFE05858)),
                            ),
                            const Text(
                              'Critical Issues',
                              style: TextStyle(fontSize: 12, color: Color(0xFFE05858), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: itemWidth,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E293B), size: 24),
                            const SizedBox(height: 8),
                            Text(
                              _attentionCount.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const Text(
                              'Attention Needed',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _alertsList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _alertsList.length,
                itemBuilder: (context, index) {
                  final alert = _alertsList[index];
                  final String status = (alert['status'] ?? 'pending').toString().toLowerCase();
                  final bool isCritical = status == 'critical' || status == 'pending';
                  final String patientName = alert['patient_name'] ?? 'Unknown Patient';
                  final String roomNumber = alert['location'] ?? 'N/A';
                  final String description = alert['condition_description'] ?? 'No vital alert description.';

                  final Color mainColor = isCritical ? const Color(0xFFE05858) : const Color(0xFFC96A1F);
                  final Color badgeBg = isCritical ? const Color(0xFFFDEBEB) : const Color(0xFFFEF5E6);
                  final String statusText = isCritical ? 'CRITICAL' : 'NEEDS ATTENTION';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertDetailsScreen(
                            patientName: patientName,
                            roomNumber: roomNumber,
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
                          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFF1F5F9),
                                backgroundImage: AssetImage('assets/images/default_avatar.png'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patientName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Room $roomNumber • Live Monitoring",
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
                                  statusText,
                                  style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.3),
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
                                Expanded(
                                  child: Text(
                                    description,
                                    style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      isCritical ? '142' : '91',
                                      style: TextStyle(color: mainColor, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      isCritical ? 'BPM' : '%',
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
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done_all_rounded, size: 60, color: Colors.green),
          SizedBox(height: 12),
          Text("No Urgent Alerts Active", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}