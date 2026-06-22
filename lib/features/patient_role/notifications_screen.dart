import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _liveNotifications = [];

  @override
  void initState() {
    super.initState();
    _fetchMyNotifications();
  }

  // جلب الإشعارات الحقيقية الخاصة بالمريض الحالي من السيرفر
  Future<void> _fetchMyNotifications() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _supabase
            .from('notifications')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false);

        setState(() {
          _liveNotifications = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      setState(() => _isLoading = false);
    }
  }

  // علامة قراءة الإشعار (تحديث الحالة في الداتابيز)
  Future<void> _markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      _fetchMyNotifications(); // إعادة جلب البيانات لتحديث الـ UI
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
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
        title: const Text(
          'Notifications',
          style: TextStyle(color: Color(0xFF1A394A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A394A)))
          : _liveNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        itemCount: _liveNotifications.length,
        itemBuilder: (context, index) {
          final notif = _liveNotifications[index];
          final String id = notif['id'].toString();
          final String title = notif['title'] ?? 'System Update';
          final String body = notif['body'] ?? '';
          final bool isRead = notif['is_read'] ?? false;

          // تحديد نوع الأيقونة واللون بناءً على محتوى الإشعار ديناميكياً
          IconData iconData = Icons.notifications_outlined;
          Color iconColor = const Color(0xFF1A394A);
          if (title.toLowerCase().contains('appointment') || title.contains('موعد')) {
            iconData = Icons.calendar_today_outlined;
            iconColor = Colors.blue;
          } else if (title.toLowerCase().contains('payment') || title.contains('دفع')) {
            iconData = Icons.account_balance_wallet_outlined;
            iconColor = Colors.green;
          }

          return _buildNotificationCard(
            id: id,
            icon: iconData,
            iconColor: iconColor,
            title: title,
            subtitle: body,
            isRead: isRead,
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isRead,
  }) {
    return GestureDetector(
      onTap: () => _markAsRead(id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF1F4F7).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isRead ? Colors.grey.shade100 : const Color(0xFF49CDCB).withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
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
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 15,
                            color: const Color(0xFF1A394A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isRead)
                        const CircleAvatar(radius: 4, backgroundColor: Color(0xFF49CDCB)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isRead ? Colors.grey : Colors.grey.shade800,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 15),
          Text(
            "Your notification center is empty",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}