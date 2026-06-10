import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A394A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for Smart Hayat Hospital',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A394A), fontSize: 16),
            ),
            SizedBox(height: 16),
            _PolicyParagraph(
              title: '1. Information Collection',
              content: 'We collect medical information, identity records, and personal account configurations solely to deliver personalized diagnostic processes and medical appointment tracking.',
            ),
            _PolicyParagraph(
              title: '2. Data Protection & Supabase Architecture',
              content: 'All user medical databases and data synchronization cycles are strictly automated through secure server relays to maintain strict cryptographic anonymity.',
            ),
            _PolicyParagraph(
              title: '3. User Access Control Rights',
              content: 'Patients retain the irrevocable authority to erase personal credentials, access logs, or file shares instantly using our primary identity management portals.',
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyParagraph extends StatelessWidget {
  final String title;
  final String content;

  const _PolicyParagraph({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A394A), fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            textAlign: TextAlign.justify, // تم تمريرها هنا داخل الـ Text بشكل صحيح ومضمون
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}