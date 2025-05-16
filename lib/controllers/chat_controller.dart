import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:whisper/models/chat_model.dart';
import 'package:whisper/models/chat_preview_model.dart';
import 'package:whisper/models/friend_request_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ChatModel> messages = <ChatModel>[].obs;

  StreamSubscription<QuerySnapshot>? _chatSubscription;
  String? _activeChatId;

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeChatIfNeeded(String currentUserId, String friendUserId) async {
    final chatId = _generateChatId(currentUserId, friendUserId);
    final chatRef = _firestore.collection('chats').doc(chatId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(chatRef);
      if (!snapshot.exists) {
        transaction.set(chatRef, {
          'participants': [currentUserId, friendUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> listenToMessages({
    required String currentUserId,
    required String friendUserId,
    int limit = 20,
  }) async {
    final chatId = _generateChatId(currentUserId, friendUserId);

    if (_activeChatId == chatId && _chatSubscription != null) return;
    await _chatSubscription?.cancel();

    _activeChatId = chatId;

    await _initializeChatIfNeeded(currentUserId, friendUserId);

    final chatRef = _firestore.collection('chats').doc(chatId);

    _chatSubscription = chatRef
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .listen((snapshot) {
      final chatMessages = snapshot.docs
          .map((doc) => ChatModel.fromDocument(doc))
          .toList();
      messages.value = chatMessages;
    });
  }

  Future<void> sendMessage({
    required String currentUserId,
    required String friendUserId,
    required String message,
  }) async {
    await _initializeChatIfNeeded(currentUserId, friendUserId);

    final chatId = _generateChatId(currentUserId, friendUserId);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    final newMessage = {
      'senderId': currentUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await messageRef.add(newMessage);
  }


  Stream<ChatPreview> getChatPreview({
    required String currentUserId,
    required String friendUserId,
  }) async* {
    final chatId = _generateChatId(currentUserId, friendUserId);
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1);

    await for (final snapshot in messagesRef.snapshots()) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final message = ChatModel.fromDocument(doc);
        yield ChatPreview(
          message: message.message.trim().isEmpty ? 'Say Hi' : message.message,
          timestamp: message.timestamp,
        );
      } else {
        final friendQuery = await _firestore
            .collection('friend_requests')
            .where('status', isEqualTo: 'accepted')
            .where('from', whereIn: [currentUserId, friendUserId])
            .where('to', whereIn: [currentUserId, friendUserId])
            .limit(1)
            .get();

        if (friendQuery.docs.isNotEmpty) {
          final acceptedRequest =
          FriendRequestModel.fromDoc(friendQuery.docs.first);
          yield ChatPreview(
            message: 'Say Hi',
            timestamp: acceptedRequest.timestamp,
          );
        } else {
          yield _defaultPreview();
        }
      }
    }
  }

  ChatPreview _defaultPreview() {
    return ChatPreview(
      message: 'Say Hi',
      timestamp: DateTime.now().subtract(const Duration(days: 365)),
    );
  }

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
