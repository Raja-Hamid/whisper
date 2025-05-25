import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/controllers/chat_controller.dart';
import 'package:whisper/models/chat_model.dart';

import '../../constants/colors.dart';

class MessageOptionsSheet extends StatelessWidget {
  final ChatModel message;

  const MessageOptionsSheet({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => renameMessage(context,message)
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () async {
              final controller = Get.find<ChatController>();
              await controller.deleteMessage(
                currentUserId: message.receiverId,
                friendUserId: message.senderId,
                messageText: message.message,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget renameMessage(BuildContext context, ChatModel message) {
  TextEditingController _controller = TextEditingController(text: message.message);

  return Builder(
    builder: (innerContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(innerContext).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: CustomColors.primaryColor1,
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter new message..',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: CustomColors.primaryColor1,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: CustomColors.primaryColor1,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: CustomColors.primaryColor1,
                          width: 3,
                        ),
                      ),
                    ),
                  ),

                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final controller = Get.find<ChatController>();
                    await controller.editMessage(
                      oldMessage: message.message,
                      newMessage: _controller.text,
                      senderId: message.senderId,
                      recieverId: message.receiverId,
                    );
                    Navigator.pop(innerContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor1,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                ),


              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

