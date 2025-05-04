import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/routes/app_pages.dart';

class AuthController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.userChanges());
    ever(_user, (_) {
      if (_user.value != null) {
        fetchUserData();
      } else {
        userModel.value = null;
      }
    });
  }

  // CHECK USER AUTHENTICATION
  bool get isAuthenticated => user != null;

  void showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoadingDialog() => Get.back();

  // SIGN-UP
  Future<void> signUp(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password}) async {
    try {
      showLoadingDialog();

      // UNIQUE USERNAME LOGIC
      QuerySnapshot existingUser = await _firestore
          .collection('users')
          .where('userName', isEqualTo: userName)
          .limit(1)
          .get();
      if (existingUser.docs.isNotEmpty) {
        hideLoadingDialog();
        Get.snackbar(
          'Username Taken',
          'This username is already in use. Please choose a different one.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      UserCredential userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredentials.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'userName': userName
      });
      hideLoadingDialog();
      Get.snackbar(
        'Sign Up Successful!',
        'You have Successfully Registered.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {},
          child: const Text(
            'Okay',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Get.toNamed(AppPages.signInScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Sign In Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // SIGN-IN
  Future<void> signIn({required String email, required String password}) async {
    try {
      showLoadingDialog();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      hideLoadingDialog();
      Get.offAllNamed(AppPages.chatsListScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Sign In Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // SIGN-OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar('Signed Out', 'Signed out Successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      Get.offAllNamed(AppPages.signInScreen);
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword({required String email}) async {
    try {
      showLoadingDialog();
      await _auth.sendPasswordResetEmail(email: email);
      hideLoadingDialog();
      Get.snackbar(
        'Success!',
        'A reset password link has been sent to $email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // HANDLE FIREBASE AUTH ERRORS
  void _handleAuthErrors(FirebaseAuthException e) {
    Get.snackbar(
      'Error',
      e.code,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // FETCH USER DATA
  Future<void> fetchUserData() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromDocument(doc);
      }
    }
  }
}
