import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Color(0xFF1A394A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'Today',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            title: 'Appointment Reminder',
            body: 'Your follow-up with Dr. Aris is scheduled for tomorrow at 10:30 AM.',
            time: '2m ago',
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF1E88E5),
            bgColor: const Color(0xFFE3F2FD),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            title: 'New Message',
            body: 'Dr. Sarah sent you a secure message regarding your lab results.',
            time: '1h ago',
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: const Color(0xFF1E88E5),
            bgColor: const Color(0xFFE3F2FD),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            title: 'Payment Successful',
            body: "Invoice #8829 for last week's physical therapy has been processed.",
            time: '4h ago',
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF4CAF50),
            bgColor: const Color(0xFFE8F5E9),
          ),
          const SizedBox(height: 24),
          const Text(
            'Yesterday',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            title: 'Records Updated',
            body: 'Your medical history has been updated with the latest vaccination records.',
            time: '1d ago',
            icon: Icons.business_center_outlined,
            iconColor: const Color(0xFFFF9800),
            bgColor: const Color(0xFFFFF3E0),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            title: 'Sync Completed',
            body: 'Cloud synchronization with your wearable device is up to date.',
            time: '1d ago',
            icon: Icons.sync,
            iconColor: const Color(0xFF1E88E5),
            bgColor: const Color(0xFFE3F2FD),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A394A),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.3,
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