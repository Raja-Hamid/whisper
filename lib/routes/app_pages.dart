import 'package:get/get.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/ui/screens/authorization/forgot_password_screen.dart';
import 'package:whisper/ui/screens/authorization/sign_in_screen.dart';
import 'package:whisper/ui/screens/authorization/sign_up_screen.dart';
import 'package:whisper/ui/screens/onboarding/splash_screen.dart';
import 'package:whisper/ui/screens/onboarding/welcome_screen.dart';
import 'package:whisper/ui/screens/chat/add_friends_screen.dart';
import 'package:whisper/ui/screens/chat/chat_screen.dart';
import 'package:whisper/ui/screens/chat/chats_list_screen.dart';
import 'package:whisper/ui/screens/chat/profile_screen.dart';

class AppPages {
  static const splashScreen = '/splashScreen';
  static const welcomeScreen = '/welcomeScreen';
  static const signInScreen = '/signInScreen';
  static const signUpScreen = '/signUpScreen';
  static const forgotPasswordScreen = '/forgotPasswordScreen';
  static const chatsListScreen = '/chatsListScreen';
  static const chatScreen = '/chatScreen';
  static const profileScreen = '/profileScreen';
  static const addFriendsScreen = '/addFriendsScreen';

  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signInScreen, page: () => const SignInScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: chatsListScreen, page: () => const ChatsListScreen()),
    GetPage(
      name: chatScreen,
      page: () {
        final user = Get.arguments as UserModel;
        return ChatScreen(receiverUser: user);
      },
    ),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: addFriendsScreen, page: () => const AddFriendsScreen()),
  ];
}
