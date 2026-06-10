// File: lib/features/nurse_role/nurse_chat_screen.dart

import 'package:flutter/material.dart';

class NurseChatScreen extends StatefulWidget {
  final String doctorName;

  const NurseChatScreen({super.key, required this.doctorName});

  @override
  State<NurseChatScreen> createState() => _NurseChatScreenState();
}

class _NurseChatScreenState extends State<NurseChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': true,
      'text': 'Good morning doctor, I\'m monitoring patient Sara in Room 402. His heart rate increased to 142 BPM',
      'time': '10:13',
    },
    {
      'isMe': false,
      'text': 'Thank you for the update. Is the patient experiencing shortness of breath or chest pain?',
      'time': '10:14',
    },
    {
      'isMe': true,
      'text': 'Yes doctor, he reported mild chest discomfort.',
      'time': '10:14',
    },
    {
      'isMe': false,
      'text': 'Please monitor his vitals every 15 minutes and administer the press',
      'time': '10:15',
    },
    {
      'isMe': true,
      'text': 'ok',
      'time': '10:16',
    },
    {
      'isMe': false,
      'isAudio': true,
      'duration': '5:04',
      'progress': '3:45',
      'time': '10:18',
    }
  ];

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(Icons.camera_alt_outlined, 'Camera'),
                  _buildAttachmentOption(Icons.image_outlined, 'Gallery'),
                  _buildAttachmentOption(Icons.description_outlined, 'File'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: const Color(0xFF007AFF), size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.doctorName,
                style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Color(0xFF132530)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Color(0xFF132530)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
        // تم حل خطأ الـ border هنا عن طريق استخدام الـ shape الرسمي للـ AppBar بشكل آمن ومطابق للديزاين
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'] ?? false;
                final bool isAudio = msg['isAudio'] ?? false;

                if (isAudio) {
                  return _buildAudioMessage(msg['progress'], msg['duration'], msg['time']);
                }

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF3B66FF) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color: isMe ? Colors.white : const Color(0xFF334155),
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            color: isMe ? Colors.white60 : const Color(0xFF94A3B8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFF475569), size: 24),
                    onPressed: _showAttachmentBottomSheet,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Write a message...',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF475569), size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(String progress, String duration, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F5F9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF3B66FF).withValues(alpha: 0.1),
                  child: const Icon(Icons.pause_rounded, color: Color(0xFF3B66FF), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: const Color(0xFFCBD5E1),
                        color: const Color(0xFF3B66FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(progress, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                          Text(duration, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 2),
            Text(time, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}