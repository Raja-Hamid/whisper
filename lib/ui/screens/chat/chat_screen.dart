import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/controllers/chat_controller.dart';
import 'package:whisper/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiverUser;
  const ChatScreen({super.key, required this.receiverUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = Get.put(ChatController());
  final _authController = Get.find<AuthController>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatController.listenToMessages(
      _authController.user!.uid,
      widget.receiverUser.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authController.user!;
    final receiver = widget.receiverUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=${receiver.firstName}+${receiver.lastName}',
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${receiver.firstName} ${receiver.lastName}',
                  style: TextStyle(color: CustomColors.white, fontSize: 18.sp),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: CustomColors.primaryColor1,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 100.h),
          padding: EdgeInsets.fromLTRB(10.0.w, 25.0.h, 10.0.w, 10.0.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withAlpha((0.8 * 255).round()),
              ],
              stops: const [0, 0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.r),
              topRight: Radius.circular(40.0.r),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final messages = _chatController.messages;

                  if (messages.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == currentUser.uid;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 14.w),
                          constraints: BoxConstraints(maxWidth: 250.w),
                          decoration: BoxDecoration(
                            color: isMe
                                ? CustomColors.primaryColor1
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                DateFormat('hh:mm a').format(msg.timestamp),
                                style: TextStyle(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.emoji_emotions),
                        hintText: 'Message',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () async {
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) {
                        await _chatController.sendMessage(
                          senderId: currentUser.uid,
                          receiverId: receiver.uid,
                          message: text,
                        );
                        _messageController.clear();
                      }
                    },
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: CustomColors.primaryColor1,
                      child: Icon(Icons.send, color: CustomColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
