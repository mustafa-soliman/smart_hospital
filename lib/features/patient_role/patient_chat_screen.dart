import 'package:flutter/material.dart';
import 'package:smart_hospital/features/patient_role/chat_attachment_popup.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  ChatMessage({required this.text, required this.isMe, required this.time});
}

class PatientChatScreen extends StatefulWidget {
  final String doctorName;
  const PatientChatScreen({super.key, required this.doctorName});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: "hello,doctor ,i believe i have the coronavirus", isMe: true, time: "10:13"),
    ChatMessage(text: "I'm here for you, don't worry.", isMe: false, time: "10:14"),
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _controller.text,
          isMe: true,
          time: "${DateTime.now().hour}:${DateTime.now().minute}",
        ));
      });
      _controller.clear();
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(ChatMessage(
              text: "Thanks for your message. I will review it and get back to you shortly.",
              isMe: false,
              time: "${DateTime.now().hour}:${DateTime.now().minute}",
            ));
          });
          _scrollToBottom();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/images/default_avatar.png')),
            const SizedBox(width: 10),
            Text(widget.doctorName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildBubble(_messages[index]);
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: message.isMe ? const Color(0xFF4A90E2) : const Color(0xFFF1F4F7),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(message.isMe ? 20 : 0),
                bottomRight: Radius.circular(message.isMe ? 0 : 20),
              ),
            ),
            child: Text(message.text, style: TextStyle(color: message.isMe ? Colors.white : Colors.black, fontSize: 14)),
          ),
          Text(message.time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      decoration: BoxDecoration(color: Colors.grey[50]),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add, color: Colors.grey), onPressed: () => _showAttachmentPopup(context)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Write a message...', border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Color(0xFF4A90E2)), onPressed: _sendMessage),
        ],
      ),
    );
  }

  void _showAttachmentPopup(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => const ChatAttachmentPopup());
  }
}