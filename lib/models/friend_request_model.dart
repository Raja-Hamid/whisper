import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String from;
  final String to;
  final String status;
  final DateTime timestamp;

  FriendRequestModel({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
    required this.timestamp,
  });

  factory FriendRequestModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendRequestModel(
      id: doc.id,
      from: data['from'],
      to: data['to'],
      status: data['status'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'status': status,
    'timestamp': Timestamp.fromDate(timestamp),
  };
}
