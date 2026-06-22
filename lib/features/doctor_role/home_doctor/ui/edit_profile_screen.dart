import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  final _supabase = Supabase.instance.client;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctorProfileData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        _emailController.text = user.email ?? '';

        final profileRes = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (profileRes != null) {
          _nameController.text = profileRes['full_name'] ?? '';
          _phoneController.text = profileRes['phone'] ?? '';
        }

        final doctorRes = await _supabase
            .from('doctors')
            .select('specialization, bio')
            .eq('user_id', user.id)
            .maybeSingle();

        if (doctorRes != null) {
          _specialtyController.text = doctorRes['specialization'] ?? '';
          _bioController.text = doctorRes['bio'] ?? '';
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B3A4B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1B3A4B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('profiles').update({
          'full_name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        }).eq('id', user.id);

        await _supabase.from('doctors').update({
          'specialization': _specialtyController.text.trim(),
          'bio': _bioController.text.trim(),
        }).eq('user_id', user.id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully! 🚀"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile data."), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5FB),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B3A4B)))
          : SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 55,
                            backgroundImage: AssetImage('assets/images/default_avatar.png'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B3A4B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildInputField(
                        label: "Full Name",
                        icon: Icons.person_outline,
                        controller: _nameController,
                        validator: (value) => value == null || value.trim().isEmpty ? "Name cannot be empty" : null,
                      ),
                      _buildInputField(
                        label: "Email",
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                        validator: (value) => value == null || value.trim().isEmpty ? "Email cannot be empty" : null,
                      ),
                      _buildInputField(
                        label: "Phone Number",
                        icon: Icons.phone_android_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.trim().isEmpty ? "Phone number cannot be empty" : null,
                      ),
                      _buildInputField(
                        label: "Specialty",
                        icon: Icons.medical_services_outlined,
                        controller: _specialtyController,
                        validator: (value) => value == null || value.trim().isEmpty ? "Specialty cannot be empty" : null,
                      ),
                      _buildInputField(
                        label: "Bio",
                        icon: null,
                        controller: _bioController,
                        maxLines: 3,
                        validator: (value) => value == null || value.trim().isEmpty ? "Bio cannot be empty" : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A4B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData? icon,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
              filled: true,
              fillColor: const Color(0xFFFBFBFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xEAEAEAFF))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xEAEAEAFF))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF1B3A4B), width: 1)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red, width: 1)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red, width: 1)),
            ),
          ),
        ],
      ),
    );
  }
}