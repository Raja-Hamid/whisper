import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/models/user_model.dart';

class UserSearchController {
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: query)
        .where('userName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }
}