import 'package:flutter/material.dart';
import 'dart:async';
// استيراد صفحة قبول الحالة للربط التلقائي
import 'package:smart_hospital/screens/case_accepted_screen.dart';

class WaitingResponsePopup extends StatefulWidget {
  const WaitingResponsePopup({super.key});

  @override
  State<WaitingResponsePopup> createState() => _WaitingResponsePopupState();
}

class _WaitingResponsePopupState extends State<WaitingResponsePopup> {

  @override
  void initState() {
    super.initState();
    // مؤقت لمحاكاة انتظار رد المستشفى (ينتقل بعد 4 ثوانٍ)
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CaseAcceptedScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية بيضاء سادة للتركيز على محتوى النافذة
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1), // اللون الرمادي الفاتح للنافذة
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة التحميل المخصصة (Circular Progress)
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1B3A4B),
                    strokeWidth: 5,
                  ),
                ),

                const SizedBox(height: 30),

                // عنوان الحالة
                const Text(
                  'Waiting for Response',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A4B),
                  ),
                ),

                const SizedBox(height: 20),

                // نص التوضيح من التصميم الخاص بك
                const Text(
                  'The hospital is reviewing the case.\nYou will be notified once a bed is\nconfirmed or if the hospital cannot\nreceive the case.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}