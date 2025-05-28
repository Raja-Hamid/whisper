import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/controllers/chat_controller.dart';
import 'package:whisper/models/chat_model.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/ui/widgets/chat_bubble.dart';
import 'package:whisper/ui/widgets/chat_input_field.dart';
import 'package:whisper/ui/widgets/delete_message_dialog.dart';
import 'package:whisper/ui/widgets/edit_message_dialog.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final _chatController = Get.find<ChatController>();
  final _authController = Get.find<AuthController>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _chatController.initializeChatIfNeeded(
      _authController.user!.uid,
      widget.receiver.uid,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _chatController.isSending) return;

    final currentUserId = _authController.user!.uid;
    final friendUserId = widget.receiver.uid;
    final timestamp = DateTime.now();

    _messageController.clear();

    final tempMessage = ChatModel(
      id: 'temp-${timestamp.millisecondsSinceEpoch}',
      senderId: currentUserId,
      receiverId: friendUserId,
      message: messageText,
      timestamp: timestamp,
      isLocal: true,
    );

    _chatController.messages.insert(0, tempMessage);

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    _chatController.sendMessage(
      currentUserId: currentUserId,
      friendUserId: friendUserId,
      message: messageText,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              child: Text(widget.receiver.firstName[0]),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiver.firstName,
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
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.videocam, color: CustomColors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.call, color: CustomColors.white),
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
                  child: StreamBuilder<List<ChatModel>>(
                    stream: _chatController.mergedMessagesStream(
                      currentUserId: _authController.user!.uid,
                      friendUserId: widget.receiver.uid,
                      limit: 20,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data ?? [];

                      if (messages.isEmpty) {
                        return const Center(child: Text("No messages yet."));
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients &&
                            messages.length > _previousMessageCount) {
                          _scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                        _previousMessageCount = messages.length;
                      });

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe =
                              msg.senderId == _authController.user!.uid;
                          return ChatBubble(
                            message: msg.message,
                            timestamp: msg.timestamp,
                            isMe: isMe,
                            isLocal: msg.isLocal,
                            onEdit: isMe && msg.id != null
                                ? () => _showEditDialog(msg)
                                : null,
                            onDelete: isMe && msg.id != null
                                ? () => _confirmDelete(msg)
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
                ChatInputField(
                  messageController: _messageController,
                  onTap: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(ChatModel msg) {
    showDialog(
      context: context,
      builder: (_) => EditMessageDialog(
        initialText: msg.message,
        onSave: (newText) {
          _chatController.editMessage(
            currentUserId: _authController.user!.uid,
            friendUserId: widget.receiver.uid,
            messageId: msg.id!,
            newMessage: newText,
          );
        },
      ),
    );
  }

  void _confirmDelete(ChatModel msg) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        onConfirm: () {
          _chatController.deleteMessage(
            currentUserId: _authController.user!.uid,
            friendUserId: widget.receiver.uid,
            messageId: msg.id!,
          );
        },
      ),
    );
  }
}
