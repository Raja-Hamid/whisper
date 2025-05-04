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
  final RxList<FriendRequestModel> receivedRequests = <FriendRequestModel>[].obs;

  // Send Friend Request
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

    // Check for existing request (from currentUser -> toUserId)
    final existingRequest = await _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: currentUserId)
        .where('to', isEqualTo: toUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    // Optional: Check reverse direction (in case target user already sent one)
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

    // All checks passed, send the request
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


  // Fetch Requests
  Future<void> fetchRequests() async {
    final currentUserId = authController.user?.uid;
    if (currentUserId == null) return;

    // Fetch sent requests
    final sentSnapshot = await _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    sentRequests.clear();
    sentRequests.addAll(
      sentSnapshot.docs.map((e) => FriendRequestModel.fromDoc(e)),
    );

    // Fetch received requests
    final receivedSnapshot = await _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    receivedRequests.clear();
    receivedRequests.addAll(
      receivedSnapshot.docs.map((e) => FriendRequestModel.fromDoc(e)),
    );
  }


  // Accept Request
  Future<void> acceptRequest(FriendRequestModel request) async {
    await _firestore
        .collection('friend_requests')
        .doc(request.id)
        .update({'status': 'accepted'});

    // Optionally: add each other to "friends" collection
    await _firestore.collection('users').doc(request.from).collection('friends').doc(request.to).set({});
    await _firestore.collection('users').doc(request.to).collection('friends').doc(request.from).set({});

    fetchRequests();
  }

  // Decline Request
  Future<void> declineRequest(FriendRequestModel request) async {
    await _firestore
        .collection('friend_requests')
        .doc(request.id)
        .update({'status': 'declined'});
    fetchRequests();
  }

  // FETCH USER DATA
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromDocument(doc);
    return null;
  }

  // Cancel Sent Request
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

}
