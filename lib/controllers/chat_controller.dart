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
  final RxList<ChatModel> localMessages = <ChatModel>[].obs;
  final RxList<ChatModel> remoteMessages = <ChatModel>[].obs;


  final RxBool _isSending = false.obs;
  bool get isSending => _isSending.value;
  set isSending(bool val) => _isSending.value = val;


  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  Future<void> initializeChatIfNeeded(
      String currentUserId, String friendUserId) async {
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

  Stream<List<ChatModel>> mergedMessagesStream({
    required String currentUserId,
    required String friendUserId,
    int limit = 20,
  }) {
    final controller = StreamController<List<ChatModel>>();
    final chatId = _generateChatId(currentUserId, friendUserId);

    final firestoreStream = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final firestoreSubscription = firestoreStream.listen((snapshot) {
      remoteMessages.value = snapshot.docs
          .map((doc) => ChatModel.fromDocument(doc))
          .toList();
      _mergeAndAddToController(controller);
    });

    final localSubscription = localMessages.listen((_) {
      _mergeAndAddToController(controller);
    });

    controller.onCancel = () {
      firestoreSubscription.cancel();
      localSubscription.cancel();
      controller.close();
    };

    return controller.stream;
  }


  void _mergeAndAddToController(StreamController<List<ChatModel>> controller) {
    final allMessages = [...localMessages, ...remoteMessages];

    final seen = <String, ChatModel>{};
    for (final msg in allMessages) {
      final key = '${msg.senderId}-${msg.message}-${msg.timestamp.millisecondsSinceEpoch ~/ 3000}';
      if (!seen.containsKey(key)) {
        seen[key] = msg;
      }
    }

    final merged = seen.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    controller.add(merged);
  }


  Stream<List<ChatModel>> listenToMessages({
    required String currentUserId,
    required String friendUserId,
    int limit = 20,
  }) {
    final chatId = _generateChatId(currentUserId, friendUserId);
    final chatRef = _firestore.collection('chats').doc(chatId);

    return chatRef
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final remote = snapshot.docs.map((doc) => ChatModel.fromDocument(doc)).toList();

      for (var remoteMsg in remote) {
        localMessages.removeWhere((local) =>
        local.message == remoteMsg.message &&
            local.senderId == remoteMsg.senderId &&
            local.timestamp.difference(remoteMsg.timestamp).inSeconds.abs() < 3
        );
      }

      remoteMessages.value = remote;
      final combined = [...localMessages, ...remote];

      messages.value = combined;
      return combined;
    });
  }


  Future<void> sendMessage({
    required String currentUserId,
    required String friendUserId,
    required String message,
  }) async {
    isSending = true;

    final chatId = _generateChatId(currentUserId, friendUserId);
    final messageRef =
    _firestore.collection('chats').doc(chatId).collection('messages');

    final timestamp = DateTime.now();
    final tempMessage = ChatModel(
      senderId: currentUserId,
      receiverId: friendUserId,
      message: message,
      timestamp: timestamp,
      isLocal: true,
    );
    localMessages.insert(0, tempMessage);

    final newMessageData = {
      'senderId': currentUserId,
      'receiverId': friendUserId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };

    try {
      await messageRef.add(newMessageData);
      localMessages.removeWhere((msg) =>
      msg.senderId == tempMessage.senderId &&
          msg.message == tempMessage.message &&
          (msg.timestamp.difference(tempMessage.timestamp).inSeconds).abs() < 3);
    } finally {
      isSending = false;
    }
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
