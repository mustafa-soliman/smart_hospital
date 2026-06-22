import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // دالة تحديث الباسورد الحقيقية في Supabase Auth
  Future<void> _updateAccountPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // أمر تحديث بيانات الأمان لليوزر الحالي
      await _supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text.trim()),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully! 🔐'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // الرجوع للإعدادات بعد النجاح
    } catch (e) {
      debugPrint("Password Update Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFF1A394A)),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A394A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Password Manager', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set a strong and secure new password to protect your clinical profile account.',
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 40),

              _buildLabel('NEW PASSWORD'),
              _buildPasswordField(
                controller: _passwordController,
                isObscure: _isObscureNew,
                onToggle: () => setState(() => _isObscureNew = !_isObscureNew),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter a new password';
                  if (val.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 25),

              _buildLabel('CONFIRM NEW PASSWORD'),
              _buildPasswordField(
                controller: _confirmPasswordController,
                isObscure: _isObscureConfirm,
                onToggle: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                validator: (val) {
                  if (val != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A394A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  onPressed: _updateAccountPassword,
                  child: const Text('Reset Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: validator,
        cursorColor: const Color(0xFF1A394A),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A394A), size: 20),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 18),
            onPressed: onToggle,
          ),
          hintText: '••••••••',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}