import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // تعريف الـ Controllers لتكون جاهزة لاستقبال وإرسال بيانات سوبابيز دوت بيز مباشرة
  final _nameController = TextEditingController(text: "Mostafa Mohamed");
  final _emailController = TextEditingController(text: "mostafa.dev@gmail.com");
  final _phoneController = TextEditingController(text: "1012345678");
  final _birthController = TextEditingController(text: "01 / 10 / 2002");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A394A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFF1A394A).withValues(alpha: 0.1),
                        child: const Icon(Icons.person, size: 60, color: Color(0xFF1A394A)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF49CDCB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    label: 'Full Name',
                    controller: _nameController,
                    icon: Icons.person_outline,
                  ),
                  _buildInputField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildInputField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    icon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildInputField(
                    label: 'Birth Date',
                    controller: _birthController,
                    icon: Icons.calendar_month_outlined,
                    isReadOnly: true,
                    onTap: () {
                      // لوجيك اختيار التاريخ مستقبلاً
                    },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // 1. هنا هتكتب كود الـ سوبابيز لتحديث البيانات لاحقاً، مثل:
                  // await supabase.from('profiles').update({...});

                  // 2. إظهار رسالة تأكيد للمستخدم بنجاح الحفظ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes saved successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 3. الرجوع التلقائي لصفحة البروفايل فوراً
                  Navigator.pop(context);
                },
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, required IconData icon, TextInputType keyboardType = TextInputType.text, bool isReadOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A394A), fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: isReadOnly,
            onTap: onTap,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF1A394A), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}