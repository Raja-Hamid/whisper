import 'package:get/get.dart';
import 'package:whisper/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
  }
}