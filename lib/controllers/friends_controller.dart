import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whisper/models/user_model.dart';

class FriendController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var receivedRequests = <Map<String, dynamic>>[].obs;
  var sentRequests = <Map<String, dynamic>>[].obs;
  var searchedUserList = <UserModel>[].obs;

  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToRequests();

    debounce(
      searchQuery,
      (String query) {
        _searchUserByPrefix(query.trim());
      },
      time: const Duration(milliseconds: 400), // debounce delay
    );
  }

  void _listenToRequests() {
    final user = _auth.currentUser;
    if (user == null) return;

    final currentUserId = user.uid;

    _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      receivedRequests.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });

    _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      sentRequests.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  Future<void> _searchUserByPrefix(String username) async {
    if (username.isEmpty) {
      searchedUserList.clear();
      return;
    }

    try {
      final result = await _firestore
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: username)
          .where('userName', isLessThanOrEqualTo: '$username\uf8ff')
          .limit(10)
          .get();

      searchedUserList.value =
          result.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    } catch (e) {
      Get.snackbar(
        'Search Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> sendFriendRequest(String toUserId) async {
    final fromUserId = _auth.currentUser!.uid;

    try {
      if (fromUserId == toUserId) {
        Get.snackbar(
          'Invalid Action',
          'You cannot send a request to yourself.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final existingRequest = await _firestore
          .collection('friend_requests')
          .where('from', isEqualTo: fromUserId)
          .where('to', isEqualTo: toUserId)
          .limit(1)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        Get.snackbar(
          'Request Exists',
          'Friend request already sent.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final fromUserDoc =
          await _firestore.collection('users').doc(fromUserId).get();
      final toUserDoc =
          await _firestore.collection('users').doc(toUserId).get();

      final fromUserName = fromUserDoc['userName'] ?? 'Unknown';
      final toUserName = toUserDoc['userName'] ?? 'Unknown';

      await _firestore.collection('friend_requests').add({
        'from': fromUserId,
        'to': toUserId,
        'fromUserName': fromUserName,
        'toUserName': toUserName,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Request Sent',
        'Friend request sent successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      Get.snackbar(
        'Request Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    final toUserId = _auth.currentUser!.uid;

    try {
      await _firestore.collection('friend_requests').doc(requestId).update({
        'status': 'accepted',
      });

      await _firestore
          .collection('users')
          .doc(fromUserId)
          .collection('friends')
          .doc(toUserId)
          .set({'status': 'accepted', 'requestedBy': toUserId});

      await _firestore
          .collection('users')
          .doc(toUserId)
          .collection('friends')
          .doc(fromUserId)
          .set({'status': 'accepted', 'requestedBy': toUserId});

      Get.snackbar(
        'Friend Added',
        'You are now friends.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } catch (e) {
      Get.snackbar(
        'Accept Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
