import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/features/patient_role/chat_attachment_popup.dart';

class PatientChatScreen extends StatefulWidget {
  final String doctorName;
  final String doctorId;

  const PatientChatScreen({
    super.key,
    required this.doctorName,
    required this.doctorId,
  });

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _supabase = Supabase.instance.client;

  List<dynamic> _liveMessages = [];
  bool _isLoading = true;
  String _currentPatientId = '';

  @override
  void initState() {
    super.initState();
    _initPatientAndChatStream();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initPatientAndChatStream() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final patientData = await _supabase
          .from('patients')
          .select('id')
          .eq('user_id', user.id)
          .single();

      _currentPatientId = patientData['id'];

      _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: true)
          .listen((data) {
        if (mounted) {
          setState(() {
            _liveMessages = data.where((msg) {
              final String sender = msg['sender_id'] ?? '';
              final String receiver = msg['receiver_id'] ?? '';
              return (sender == _currentPatientId && receiver == widget.doctorId) ||
                  (sender == widget.doctorId && receiver == _currentPatientId);
            }).toList();
            _isLoading = false;
          });
          _scrollToBottom();
        }
      });
    } catch (e) {
      debugPrint("Error initializing chat stream: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendLiveMessage() async {
    final String text = _controller.text.trim();
    if (text.isEmpty || _currentPatientId.isEmpty) return;

    _controller.clear();

    try {
      await _supabase.from('messages').insert({
        'sender_id': _currentPatientId,
        'receiver_id': widget.doctorId,
        'message_text': text,
      });
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 1), () async {
        try {
          await _supabase.from('messages').insert({
            'sender_id': widget.doctorId,
            'receiver_id': _currentPatientId,
            'message_text': "Hello! I have received your message regarding your medical profile. I will review your case file thoroughly and get back to you shortly.",
          });
        } catch (e) {
          debugPrint("Error sending automated response: $e");
        }
      });

    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.doctorName,
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0061C4)))
                : _liveMessages.isEmpty
                ? _buildEmptyChatState()
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _liveMessages.length,
              itemBuilder: (context, index) {
                final msg = _liveMessages[index];
                final bool isMe = msg['sender_id'] == _currentPatientId;
                final String text = msg['message_text'] ?? '';
                final String rawTime = msg['created_at'] ?? '';
                final String timeStr = rawTime.length >= 16 ? rawTime.substring(11, 16) : 'Now';

                return _buildChatBubble(text, isMe, timeStr);
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF0061C4) : const Color(0xFFF1F4F7),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14),
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
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
          IconButton(
            icon: const Icon(Icons.add, color: Colors.grey),
            onPressed: () => _showAttachmentPopup(context),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Write a message...', border: InputBorder.none),
                onSubmitted: (_) => _sendLiveMessage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0061C4)),
            onPressed: _sendLiveMessage,
          ),
        ],
      ),
    );
  }

  void _showAttachmentPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatAttachmentPopup(),
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            "Say hello to ${widget.doctorName}! 👋",
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}