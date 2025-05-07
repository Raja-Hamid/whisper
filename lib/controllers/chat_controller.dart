import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:whisper/models/chat_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ChatModel> messages = <ChatModel>[].obs;
  DocumentSnapshot? _lastFetchedMessage;


  void listenToMessages(String currentUserId, String friendUserId) {
    final chatId = _generateChatId(currentUserId, friendUserId);
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .listen((snapshot) {
      final newMessages =
          snapshot.docs.map((doc) => ChatModel.fromDocument(doc)).toList();
      messages.assignAll(newMessages);
      if (snapshot.docs.isNotEmpty) {
        _lastFetchedMessage = snapshot.docs.last;
      }
    });
  }

  Stream<List<ChatModel>> getMessagesPaginated({
    required String currentUserId,
    required String friendUserId,
    required int limit,
    DocumentSnapshot? startAfter,
  }) {
    final chatId = _generateChatId(currentUserId, friendUserId);
    var query = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.snapshots().map((snapshot) {
      final messages =
          snapshot.docs.map((doc) => ChatModel.fromDocument(doc)).toList();
      if (snapshot.docs.isNotEmpty) {
        _lastFetchedMessage = snapshot.docs.last;
      }
      return messages;
    });
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = _generateChatId(senderId, receiverId);
    final chatRef = _firestore.collection('chats').doc(chatId);

    final localTimestamp = DateTime.now();
    messages.insert(
      0,
      ChatModel(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: localTimestamp,
      ),
    );

    final doc = await chatRef.get();
    if (!doc.exists) {
      await chatRef.set({
        'participants': [senderId, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': localTimestamp,
      'serverTimestamp': FieldValue.serverTimestamp(),
    });
  }

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
