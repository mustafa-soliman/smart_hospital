class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final String type; // text, image, voice

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.type = 'text',
  });

  // ده اللي هنستخدمه لما نربط بالفايربيز لتحويل البيانات لـ JSON
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type,
    };
  }

  // وده لاستقبال البيانات من الفايربيز
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      type: map['type'],
    );
  }
}