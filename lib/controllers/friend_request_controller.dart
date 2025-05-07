import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/models/friend_request_model.dart';
import 'package:whisper/models/user_model.dart';

class FriendRequestController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authController = Get.find<AuthController>();

  final RxList<FriendRequestModel> sentRequests = <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> receivedRequests =
      <FriendRequestModel>[].obs;

  late StreamSubscription<QuerySnapshot> _sentRequestSub;
  late StreamSubscription<QuerySnapshot> _receivedRequestSub;
  final Map<String, UserModel> _userCache = {};

  @override
  void onClose() {
    _sentRequestSub.cancel();
    _receivedRequestSub.cancel();
    super.onClose();
  }

  // SEND FRIEND REQUEST
  Future<void> sendRequest(String toUserId) async {
    final currentUserId = authController.user?.uid;

    if (currentUserId == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    if (currentUserId == toUserId) {
      Get.snackbar(
        'Invalid Action',
        'You cannot send a friend request to yourself.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final existingRequest = await _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: currentUserId)
        .where('to', isEqualTo: toUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    final reverseRequest = await _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: toUserId)
        .where('to', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (existingRequest.docs.isNotEmpty) {
      Get.snackbar(
        'Already Sent',
        'You already sent a request to this user.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    if (reverseRequest.docs.isNotEmpty) {
      Get.snackbar(
        'Request Already Received',
        'This user has already sent you a friend request. Check your received requests.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purple,
        colorText: Colors.white,
      );
      return;
    }

    await _firestore.collection('friend_requests').add({
      'from': currentUserId,
      'to': toUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    Get.snackbar(
      'Request Sent',
      'Friend request sent successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // FETCH REQUESTS
  void fetchRequests() {
    final currentUserId = authController.user?.uid;
    if (currentUserId == null) return;

    _sentRequestSub = _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      sentRequests.value =
          snapshot.docs.map((e) => FriendRequestModel.fromDoc(e)).toList();
    });

    _receivedRequestSub = _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      receivedRequests.value =
          snapshot.docs.map((e) => FriendRequestModel.fromDoc(e)).toList();
    });
  }

  // ACCEPT REQUEST
  Future<void> acceptRequest(FriendRequestModel request) async {
    await _firestore.collection('friend_requests').doc(request.id).update({
      'status': 'accepted',
    });

    await _firestore
        .collection('users')
        .doc(request.from)
        .collection('friends')
        .doc(request.to)
        .set({'timestamp': FieldValue.serverTimestamp()});

    await _firestore
        .collection('users')
        .doc(request.to)
        .collection('friends')
        .doc(request.from)
        .set({'timestamp': FieldValue.serverTimestamp()});

    final user = await getUserById(request.from);
    Get.snackbar(
      'Request Accepted',
      user != null
          ? 'You are now friends with ${user.firstName}.'
          : 'Friend request accepted.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // DECLINE REQUEST
  Future<void> declineRequest(FriendRequestModel request) async {
    await _firestore
        .collection('friend_requests')
        .doc(request.id)
        .update({'status': 'declined'});
  }

  // FETCH USER DATA
  Future<UserModel?> getUserById(String uid) async {
    if (_userCache.containsKey(uid)) {
      return _userCache[uid];
    }

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final user = UserModel.fromDocument(doc);
      _userCache[uid] = user;
      return user;
    }
    return null;
  }

  // CANCEL SENT REQUEST
  Future<void> cancelRequest(FriendRequestModel request) async {
    try {
      await _firestore.collection('friend_requests').doc(request.id).delete();

      // Optionally remove it locally from the list
      sentRequests.removeWhere((r) => r.id == request.id);

      Get.snackbar(
        'Request Cancelled',
        'Friend request has been cancelled.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel the request.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // FRIENDS LIST
  Stream<List<UserModel>> getFriendsStream() {
    final currentUserId = authController.user?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final users = <UserModel>[];

      for (var doc in snapshot.docs) {
        final userId = doc.id;
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          users.add(UserModel.fromDocument(userDoc));
        }
      }
      return users;
    });
  }
}
