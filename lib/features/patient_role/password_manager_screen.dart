import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/forgot_password_screen.dart';

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A394A), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Password Manager',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildLabel('Current Password'),
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    isObscure: _isObscureCurrent,
                    onToggle: () => setState(() => _isObscureCurrent = !_isObscureCurrent),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // تمرير الـ userRole كـ 'Patient' لتطابق لوجيك مشروعك وتختفي المشكلة
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(userRole: 'Patient'),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  _buildLabel('New Password'),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    isObscure: _isObscureNew,
                    onToggle: () => setState(() => _isObscureNew = !_isObscureNew),
                  ),

                  const SizedBox(height: 20),
                  _buildLabel('Confirm New Password'),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    isObscure: _isObscureConfirm,
                    onToggle: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A394A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(text, style: const TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required bool isObscure, required VoidCallback onToggle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        cursorColor: const Color(0xFF1A394A),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_person_rounded, color: Color(0xFF1A394A), size: 22),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade600, size: 20),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          hintText: '***********',
          hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
        ),
      ),
    );
  }
}