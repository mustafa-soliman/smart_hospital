import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/upload_record_screen.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _recordsList = [];

  @override
  void initState() {
    super.initState();
    _fetchMyMedicalRecords();
  }

  // جلب الروشتات والتقارير الطبية الحقيقية للمريض الحالي من السيرفر
  Future<void> _fetchMyMedicalRecords() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        // سحب السجلات الطبية مع اسم الدكتور وتخصصه اللي كتب الروشتة
        final data = await _supabase
            .from('medical_records')
            .select('*, doctors(specialization, profiles(full_name))')
            .eq('patient_id', user.id)
            .order('created_at', ascending: false);

        setState(() {
          _recordsList = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching medical records: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Medical Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Access and manage all your clinical documentation in one secure environment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search records...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // عرض لودينج أثناء جلب البيانات أو عرض السجلات الحقيقية
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
                  : _recordsList.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: _recordsList.length,
                itemBuilder: (context, index) {
                  final record = _recordsList[index];
                  final doctor = record['doctors'];
                  final docProfile = doctor?['profiles'];

                  // تجهيز النصوص لايف من قاعدة البيانات
                  final String docName = docProfile != null ? docProfile['full_name'] ?? 'Dr. Specialist' : 'Dr. Specialist';
                  final String diagnosis = record['diagnosis'] ?? 'General Checkup Consultation';
                  final String rawDate = record['created_at'] ?? '';
                  final String formattedDate = rawDate.length >= 10 ? rawDate.substring(0, 10) : 'Recent';

                  return _buildRecordCard(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Report by $docName',
                    date: formattedDate,
                    subtitle: diagnosis,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, {required IconData icon, required String title, required String date, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F7)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE8F1F9), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF1A394A)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A394A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(date, style: const TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // هنا يمكن عرض بوب اب تفصيلي للروشتة والتشخيص بالكامل عند الضغط
                    _showRecordDetailsDialog(context, title, subtitle, date);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A394A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text('View', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFE8F1F9), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.download_outlined, color: Color(0xFF1A394A), size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRecordDetailsDialog(BuildContext context, String title, String content, String date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            const Text('Diagnosis & Treatment Plan:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(content, style: const TextStyle(color: Colors.black87, height: 1.4)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Color(0xFF1A394A))))
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No medical records available yet.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}