import 'package:get/get.dart';
import 'package:whisper/ui/screens/authorization/forgot_password_screen.dart';
import 'package:whisper/ui/screens/authorization/sign_in_screen.dart';
import 'package:whisper/ui/screens/authorization/sign_up_screen.dart';
import 'package:whisper/ui/screens/authorization/welcome_screen.dart';
import 'package:whisper/ui/screens/chat/add_friends_screen.dart';
import 'package:whisper/ui/screens/chat/chat_screen.dart';
import 'package:whisper/ui/screens/chat/chats_list_screen.dart';
import 'package:whisper/ui/screens/chat/profile_screen.dart';

class AppPages {
  static const welcomeScreen = '/welcomeScreen';
  static const signInScreen = '/signInScreen';
  static const signUpScreen = '/signUpScreen';
  static const forgotPasswordScreen = '/forgotPasswordScreen';
  static const chatsListScreen = '/chatsListScreen';
  static const chatScreen = '/chatScreen';
  static const profileScreen = '/profileScreen';
  static const addFriendsScreen = '/addFriendsScreen';

  static final routes = [
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signInScreen, page: () => const SignInScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: chatsListScreen, page: () => const ChatsListScreen()),
    GetPage(name: chatScreen, page: () => const ChatScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: addFriendsScreen, page: () => const AddFriendsScreen()),
  ];
}
