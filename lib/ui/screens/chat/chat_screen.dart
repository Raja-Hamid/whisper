import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/controllers/chat_controller.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/ui/widgets/chat_bubble.dart';
import 'package:whisper/ui/widgets/chat_input_field.dart';

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

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _chatController.listenToMessages(
      currentUserId: _authController.user!.uid,
      friendUserId: widget.receiverUser.uid,
    );
  }

  void _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    _messageController.clear();
    FocusScope.of(context).unfocus();

    setState(() => _isSending = true);

    await _chatController.sendMessage(
      currentUserId: _authController.user!.uid,
      friendUserId: widget.receiverUser.uid,
      message: text,
    );


    setState(() => _isSending = false);

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _chatController.messages.clear();
    super.dispose();
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
        leadingWidth: 45.w,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              child: Text(
                receiver.firstName[0],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiver.firstName,
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: CustomColors.grey,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.videocam,
              color: CustomColors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.call,
                color: CustomColors.white,
              ),
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight,
        iconTheme: IconThemeData(color: CustomColors.white, size: 25.sp),
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
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      final messages = _chatController.messages;

                      if (messages.isEmpty) {
                        return const Center(child: Text("No messages yet."));
                      }

                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                      );
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == currentUser.uid;
                          return ChatBubble(
                            message: msg.message,
                            timestamp: msg.timestamp,
                            isMe: isMe,
                          );
                        },
                      );
                    },
                  ),
                ),
                ChatInputField(
                  messageController: _messageController,
                  onTap: _handleSend,
                  isSending: _isSending,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
