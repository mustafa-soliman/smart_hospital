import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showCancelAppointmentDialog(BuildContext context, {String? appointmentId, VoidCallback? onCancelSuccess}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isDeleting = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFC62828),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Cancel Appointment?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Are you sure you want to cancel this appointment? This action cannot be undone and you may lose your preferred time slot.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: isDeleting
                        ? null
                        : () async {
                      if (appointmentId == null) {
                        Navigator.pop(context);
                        return;
                      }
                      setState(() => isDeleting = true);
                      try {
                        await Supabase.instance.client
                            .from('appointments')
                            .delete()
                            .eq('id', appointmentId);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (onCancelSuccess != null) {
                            onCancelSuccess();
                          }
                        }
                      } catch (e) {
                        setState(() => isDeleting = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: isDeleting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text(
                      'Cancel Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: isDeleting ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F4F7),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Keep Appointment',
                      style: TextStyle(
                        color: Color(0xFF1A394A),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}