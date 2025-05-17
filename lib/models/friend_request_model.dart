import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String from;
  final String to;
  final String status;
  final DateTime timestamp;
  final List<String> participants;

  FriendRequestModel({
    required this.id,
    required this.from,
    required this.to,
    required this.status,
    required this.timestamp,
    required this.participants,
  });

  factory FriendRequestModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<String> participantsFromDoc = [];
    if (data.containsKey('participants')) {
      participantsFromDoc = List<String>.from(data['participants']);
    } else {
      participantsFromDoc = [data['from'], data['to']]..sort();
    }

    return FriendRequestModel(
      id: doc.id,
      from: data['from'],
      to: data['to'],
      status: data['status'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      participants: participantsFromDoc,
    );
  }

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'status': status,
    'timestamp': Timestamp.fromDate(timestamp),
    'participants': participants,
  };
}
