import 'package:flutter/material.dart';
import 'package:smart_hospital/screens/contact_admin_screen.dart';
import 'package:smart_hospital/screens/emergency_case_screen.dart';
import 'package:smart_hospital/screens/paramedic_auth_service.dart';

class ParamedicLoginScreen extends StatefulWidget {
  const ParamedicLoginScreen({super.key});

  @override
  State<ParamedicLoginScreen> createState() => _ParamedicLoginScreenState();
}

class _ParamedicLoginScreenState extends State<ParamedicLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final ParamedicAuthService _authService = ParamedicAuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hospital_bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withOpacity(0.3)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Center(
                          child: Text(
                            'Paramedic Log in',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          'Paramedic ID',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A4B)),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _idController,
                          decoration: InputDecoration(
                            hintText: 'Enter your ID',
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1B3A4B)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _isLoading ? null : () async {
                            if (_idController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter your Paramedic ID')),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);
                            bool isValid = await _authService.verifyParamedicId(_idController.text.trim());
                            setState(() => _isLoading = false);

                            if (isValid) {
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EmergencyCaseScreen()),
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid Paramedic ID. Please try again.')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B3A4B),
                            minimumSize: const Size(double.infinity, 60),
                            shape: const StadiumBorder(),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(child: SizedBox(height: 40)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an Id ? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ContactAdminScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "Contact Admin",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}