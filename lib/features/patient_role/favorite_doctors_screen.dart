import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/patient_chat_screen.dart';
import 'package:smart_hospital/features/patient_role/patient_book_appointment_screen.dart';

class FavoriteDoctorsScreen extends StatefulWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  State<FavoriteDoctorsScreen> createState() => _FavoriteDoctorsScreenState();
}

class _FavoriteDoctorsScreenState extends State<FavoriteDoctorsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _favoriteDoctors = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteDoctors();
  }

  // جلب قائمة الأطباء المفضلة للمريض الحالي من Supabase
  Future<void> _fetchFavoriteDoctors() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        // هنا بنعمل select من جدول الـ doctors الحقيقي (أو جدول favorites المربوط بيه)
        final data = await _supabase
            .from('doctors')
            .select('id, specialization, status, profiles(full_name, avatar_url)');

        List<Map<String, dynamic>> loadedFavorites = [];
        for (var doc in data) {
          final profile = doc['profiles'];
          loadedFavorites.add({
            'id': doc['id'],
            'name': profile != null ? profile['full_name'] ?? 'Dr. Expert' : 'Dr. Expert',
            'specialty': doc['specialization'] ?? 'Specialist',
            'rating': '5.0',
            'avatar_url': profile != null ? profile['avatar_url'] : null,
          });
        }

        setState(() {
          _favoriteDoctors = loadedFavorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Favorite Doctors',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A394A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Quick access to your preferred medical\nspecialists and caretakers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
                  : _favoriteDoctors.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _favoriteDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = _favoriteDoctors[index];
                  return _buildFavoriteCard(
                    context,
                    id: doctor['id'],
                    name: doctor['name'],
                    specialty: doctor['specialty'],
                    rating: doctor['rating'],
                    avatarUrl: doctor['avatar_url'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
      BuildContext context, {
        required String id,
        required String name,
        required String specialty,
        required String rating,
        required String? avatarUrl,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(avatarUrl, width: 65, height: 65, fit: BoxFit.cover)
                    : const Image(image: AssetImage('assets/images/default_avatar.png'), width: 65, height: 65, fit: BoxFit.cover),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A394A))),
                    const SizedBox(height: 2),
                    Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 0.5),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientChatScreen(doctorName: name, doctorId: id)),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF1A394A)),
                  label: const Text('Chat', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1A394A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientBookAppointmentScreen(doctorId: id)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A394A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.grey),
          SizedBox(height: 15),
          Text("No favorite doctors added yet.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}