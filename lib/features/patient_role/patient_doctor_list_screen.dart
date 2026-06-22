import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/patient_doctor_details_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_filter_screen.dart';

class PatientDoctorListScreen extends StatefulWidget {
  const PatientDoctorListScreen({super.key});

  @override
  State<PatientDoctorListScreen> createState() => _PatientDoctorListScreenState();
}

class _PatientDoctorListScreenState extends State<PatientDoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _supabase = Supabase.instance.client;

  int selectedCategoryIndex = 0;
  final List<String> categories = ['All', 'Cardiologist', 'Dentist', 'Neurologist'];

  String currentSpecialty = 'All';
  RangeValues currentPriceRange = const RangeValues(200, 350);
  int currentRating = 4;

  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorsData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDoctorsData() async {
    try {
      final data = await _supabase
          .from('doctors')
          .select('id, specialization, consultation_fee, rating, status, profiles(full_name, avatar_url)');

      List<Map<String, dynamic>> loadedDoctors = [];
      for (var doc in data) {
        final profile = doc['profiles'] as Map<String, dynamic>?;
        loadedDoctors.add({
          'id': doc['id'],
          'name': profile != null ? profile['full_name'] ?? 'Dr. Unknown' : 'Dr. Unknown',
          'specialty': doc['specialization'] ?? 'General Practitioner',
          'price': double.tryParse(doc['consultation_fee']?.toString() ?? '200') ?? 200.0,
          'rating': double.tryParse(doc['rating']?.toString() ?? '5.0') ?? 5.0,
          'avatar_url': profile != null ? profile['avatar_url'] : null,
        });
      }

      setState(() {
        _allDoctors = loadedDoctors;
        _filteredDoctors = loadedDoctors;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    _applyAllFilters();
  }

  void _applyAllFilters() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      _filteredDoctors = _allDoctors.where((doctor) {
        final name = doctor['name'].toString().toLowerCase();
        final specialty = doctor['specialty'].toString().toLowerCase();
        final double price = doctor['price'];
        final double rating = doctor['rating'];

        bool matchesSearch = name.contains(query) || specialty.contains(query);

        String activeSpecialty = currentSpecialty != 'All'
            ? currentSpecialty
            : (selectedCategoryIndex != 0 ? categories[selectedCategoryIndex] : 'All');

        bool matchesSpecialty = activeSpecialty == 'All' || specialty == activeSpecialty.toLowerCase();

        bool matchesPrice = price >= currentPriceRange.start && price <= currentPriceRange.end;
        bool matchesRating = rating >= currentRating;

        return matchesSearch && matchesSpecialty && matchesPrice && matchesRating;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Your Doctor',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSearchBarRow(context),
            const SizedBox(height: 20),
            _buildCategoriesHorizontalList(),
            const SizedBox(height: 20),
            _buildAvailabilityHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
                  : _filteredDoctors.isEmpty
                  ? _buildEmptyState()
                  : _buildDoctorsListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search doctor or specialty...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () async {
              final Map<String, dynamic>? filterResults = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientFilterScreen(
                    selectedSpecialty: currentSpecialty,
                    currentPriceRange: currentPriceRange,
                    currentRating: currentRating,
                  ),
                ),
              );

              if (filterResults != null) {
                currentSpecialty = filterResults['specialty'];
                currentPriceRange = filterResults['priceRange'];
                currentRating = filterResults['rating'];
                _applyAllFilters();
              }
            },
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: const Icon(Icons.tune, color: Color(0xFF4A90E2)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoriesHorizontalList() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
                currentSpecialty = 'All';
                _applyAllFilters();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredDoctors.length} Doctors available',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
          ),
          const Row(
            children: [
              Text('Near me', style: TextStyle(color: Color(0xFF4A90E2))),
              Icon(Icons.location_on, color: Color(0xFF4A90E2), size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = _filteredDoctors[index];
        final String docId = doctor['id'];
        final String? avatar = doctor['avatar_url'];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDoctorDetailsScreen(doctorId: docId),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10)],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: avatar != null && avatar.isNotEmpty
                      ? Image.network(avatar, width: 85, height: 85, fit: BoxFit.cover)
                      : Container(
                    width: 85,
                    height: 85,
                    color: const Color(0xFFF1F4F7),
                    child: const Icon(Icons.person, color: Colors.grey, size: 40),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctor['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A394A)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFF4A90E2), size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  doctor['rating'].toString(),
                                  style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(doctor['specialty'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${doctor['price'].round()}EGP /visit",
                            style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDoctorDetailsScreen(doctorId: docId),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE3F2FD),
                              foregroundColor: const Color(0xFF4A90E2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('BOOK NOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text("No doctors found with current criteria.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}