import 'package:flutter/material.dart';
import 'package:smart_hospital/main.dart';
import 'package:smart_hospital/screens/home_screen.dart';
import 'package:smart_hospital/features/patient_role/PatientMainScreen.dart';
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/main_layout.dart';
import 'package:smart_hospital/features/nurse_role/nurse_dashboard_wrapper.dart';

class SignUpScreen extends StatefulWidget {
  final String userRole;
  const SignUpScreen({super.key, required this.userRole});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specialtyController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'full_name': _nameController.text.trim(),
          'role': widget.userRole.trim(),
        },
      );

      if (!mounted) return;

      if (widget.userRole.trim().toLowerCase() == 'doctor' && response.user != null) {
        await supabase.from('doctors').update({
          'specialization': _specialtyController.text.trim().isEmpty
              ? 'General Practitioner'
              : _specialtyController.text.trim(),
          'license_number': _licenseController.text.trim(),
        }).eq('user_id', response.user!.id);
      }

      if (!mounted) return;

      final String role = widget.userRole.trim().toLowerCase();
      Widget nextScreen;

      if (role == 'patient') {
        nextScreen = const PatientMainScreen();
      } else if (role == 'doctor') {
        nextScreen = const MainLayout();
      } else if (role == 'nurse') {
        nextScreen = const NurseDashboardWrapper();
      } else {
        nextScreen = HomeScreen(userRole: widget.userRole);
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen)
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Error: ${error.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDoctor = widget.userRole.trim().toLowerCase() == 'doctor';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.6)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Sign Up as ${widget.userRole}',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                    ),
                    const SizedBox(height: 25),
                    _buildField("Full Name", Icons.person_outline, "Dr. Mustafa Mohamed", _nameController),
                    const SizedBox(height: 15),
                    _buildField("Email", Icons.email_outlined, "mustafa@gmail.com", _emailController, isEmail: true),
                    const SizedBox(height: 15),
                    _buildField("Password", Icons.lock_outline, "************", _passwordController, isPass: true),
                    if (isDoctor) ...[
                      const SizedBox(height: 15),
                      _buildField("Specialization (التخصص)", Icons.medical_services_outlined, "Cardiologist", _specialtyController),
                      const SizedBox(height: 15),
                      _buildField("License Number (رقم الرخصة)", Icons.assignment_outlined, "LC-998877", _licenseController),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3A4B),
                          minimumSize: const Size(double.infinity, 55),
                          shape: const StadiumBorder()
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ? "),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text("Sign In", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, IconData icon, String hint, TextEditingController controller, {bool isPass = false, bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPass,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return "$label cannot be empty";
            if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return "Enter a valid email";
            if (isPass && value.trim().length < 6) return "Password must be at least 6 characters";
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ],
    );
  }
}