import 'package:flutter/material.dart';
import 'package:smart_hospital/main.dart';
import 'package:smart_hospital/screens/sign_up_screen.dart';
import 'package:smart_hospital/screens/forgot_password_screen.dart';
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/main_layout.dart';
import 'package:smart_hospital/features/nurse_role/nurse_dashboard_wrapper.dart';
import 'package:smart_hospital/features/patient_role/PatientMainScreen.dart';

class SignInScreen extends StatefulWidget {
  final String userRole;
  const SignInScreen({super.key, required this.userRole});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      final userId = response.user?.id;
      if (userId == null) throw Exception("User ID not found");

      final userData = await supabase
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final String dbRole = (userData['role'] ?? 'patient').toString().trim().toLowerCase();
      final String currentScreenRole = widget.userRole.trim().toLowerCase();

      if (dbRole != currentScreenRole) {
        await supabase.auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This account is registered as $dbRole, not $currentScreenRole!"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!mounted) return;

      if (dbRole == 'doctor') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainLayout()));
      } else if (dbRole == 'nurse') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const NurseDashboardWrapper()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const PatientMainScreen()));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withValues(alpha: 0.5)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text('Sign In as ${widget.userRole}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
                  const SizedBox(height: 40),
                  _buildTextField("Email", Icons.email_outlined, "mustafa@gmail.com", _emailController),
                  const SizedBox(height: 20),
                  _buildTextField("Password", Icons.lock_outline, "************", _passwordController, isPass: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen(userRole: widget.userRole))
                      ),
                      child: const Text('Forgot Password ?', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3A4B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: const StadiumBorder()
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ? "),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen(userRole: widget.userRole))
                        ),
                        child: const Text("Sign Up", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint, TextEditingController controller, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B))),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}