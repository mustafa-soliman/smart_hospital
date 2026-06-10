import 'package:flutter/material.dart';

class PrivacyPolicyModel {
  final String lastUpdate;
  final List<String> privacyParagraphs;
  final List<String> termsConditions;

  PrivacyPolicyModel({
    required this.lastUpdate,
    required this.privacyParagraphs,
    required this.termsConditions,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      lastUpdate: json['last_update'] ?? '',
      privacyParagraphs: List<String>.from(json['privacy_paragraphs'] ?? []),
      termsConditions: List<String>.from(json['terms_conditions'] ?? []),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  final PrivacyPolicyModel data;

  const PrivacyPolicyScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xffF3F4F6),
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Color(0xff0F2D4A),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            Text(
              'Last Update: ${data.lastUpdate}',
              style: const TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ...data.privacyParagraphs.map((paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                paragraph,
                style: const TextStyle(
                  color: Color(0xff4B5563),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            )),
            const SizedBox(height: 8),
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                color: Color(0xff0F2D4A),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            ...data.termsConditions.asMap().entries.map((entry) {
              int index = entry.key + 1;
              String text = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$index.',
                        style: const TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}