import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patient_details_nurse_screen.dart';

class TotalPatientsScreen extends StatefulWidget {
  const TotalPatientsScreen({super.key});

  @override
  State<TotalPatientsScreen> createState() => _TotalPatientsScreenState();
}

class _TotalPatientsScreenState extends State<TotalPatientsScreen> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _isLoading = true;
  List<dynamic> _allPatientsList = [];
  List<dynamic> _filteredPatientsList = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientsByDate(selectedDate);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatientsByDate(DateTime date) async {
    setState(() => _isLoading = true);
    try {
      final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final data = await _supabase
          .from('appointments')
          .select('patients(*, profiles(full_name, avatar_url))')
          .eq('appointment_date', formattedDate);

      final Map<String, dynamic> uniquePatients = {};
      for (var item in data) {
        if (item['patients'] != null) {
          final patient = item['patients'];
          uniquePatients[patient['id']] = patient;
        }
      }

      final loadedPatients = uniquePatients.values.toList();

      if (mounted) {
        setState(() {
          _allPatientsList = loadedPatients;
          _filteredPatientsList = loadedPatients;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching patients by date: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _fetchPatientsByDate(date);
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007AFF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF132530),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      _onDateSelected(picked);
    }
  }

  void _filterPatients(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPatientsList = _allPatientsList;
      });
      return;
    }

    setState(() {
      _filteredPatientsList = _allPatientsList.where((patient) {
        final profile = patient['profiles'];
        final String name = (profile?['full_name'] ?? '').toString().toLowerCase();
        final String blood = (patient['blood_type'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase()) || blood.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Hospital Patients",
          style: TextStyle(color: Color(0xFF132530), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF1F4F7),
              child: IconButton(
                icon: const Icon(Icons.calendar_month, color: Color(0xFF132530), size: 20),
                onPressed: () => _pickCustomDate(context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF132530)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_filteredPatientsList.length} Patients on this day",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _onDateSelected(DateTime.now()),
                    child: const Text("Today", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 15,
                itemBuilder: (context, index) {
                  final day = selectedDate.add(Duration(days: index - 2));
                  final bool isSelected = day.day == selectedDate.day && day.month == selectedDate.month && day.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () => _onDateSelected(day),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFF1F4F7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekDayLetter(day.weekday),
                            style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            day.day.toString(),
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterPatients,
                  decoration: const InputDecoration(
                    hintText: 'Search by patient name or blood type...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF007AFF)))
                  : _filteredPatientsList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredPatientsList.length,
                itemBuilder: (context, index) {
                  final patient = _filteredPatientsList[index];
                  final profile = patient['profiles'];
                  final String patientName = profile?['full_name'] ?? 'Unknown Patient';
                  final String bloodType = patient['blood_type'] ?? 'N/A';
                  final String gender = patient['gender'] ?? 'Male';
                  final String? avatarUrl = profile?['avatar_url'];

                  int age = 24;
                  if (patient['date_of_birth'] != null) {
                    age = DateTime.now().year - DateTime.parse(patient['date_of_birth'].toString()).year;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patientName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Age: $age  •  $gender",
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF007AFF).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Blood: $bloodType",
                                  style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsNurseScreen(
                                  patientName: patientName,
                                  roomNumber: "Gen Registry",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
          Icon(Icons.person_search_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text("No Registered Patients Found", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month - 1];
  }

  String _getWeekDayLetter(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }
}