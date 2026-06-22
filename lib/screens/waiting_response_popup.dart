import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_hospital/screens/case_accepted_screen.dart';
import 'package:smart_hospital/screens/case_rejected_screen.dart';

class WaitingResponsePopup extends StatefulWidget {
  final bool simulateAcceptance;
  final String caseId;

  const WaitingResponsePopup({
    super.key,
    required this.caseId,
    this.simulateAcceptance = true,
  });

  @override
  State<WaitingResponsePopup> createState() => _WaitingResponsePopupState();
}

class _WaitingResponsePopupState extends State<WaitingResponsePopup> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        if (widget.simulateAcceptance) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CaseAcceptedScreen(
                bedNumber: '14',
                floor: '3',
                department: 'Emergency',
                hospitalName: 'SHH',
                caseId: widget.caseId,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CaseRejectedScreen(caseId: widget.caseId),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
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
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1B3A4B),
                    strokeWidth: 5,
                  ),
                ),
                const SizedBox(height: 30),
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