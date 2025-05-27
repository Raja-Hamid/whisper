import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isLocal;

  const ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isLocal = false,
  });

  factory ChatModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isLocal: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
