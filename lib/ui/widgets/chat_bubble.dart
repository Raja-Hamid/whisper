import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:whisper/models/chat_model.dart';

import 'message_options.dart';

class ChatBubble extends StatelessWidget {
  final ChatModel messageModel;
  final String message;
  final DateTime timestamp;
  final bool isMe;
  final bool isLocal;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isMe,
    this.isLocal = false, required this.messageModel,
  });

  @override
  Widget build(BuildContext context) {
    Widget bubble = Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      constraints: BoxConstraints(maxWidth: 260.w),
      decoration: BoxDecoration(
        color: isMe ? CustomColors.primaryColor1 : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 0),
          bottomRight: Radius.circular(isMe ? 0 : 18.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('hh:mm a').format(timestamp),
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.black54,
                  fontSize: 11.sp,
                ),
              ),
              if (isLocal && isMe) ...[
                SizedBox(width: 6.w),
                SizedBox(
                  width: 12.r,
                  height: 12.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );

    if (isMe) {
      bubble = GestureDetector(
        onTap: () {
          showModalBottomSheet(context: context, builder: (context)=>
              MessageOptionsSheet(message: messageModel

              ));
        },
        child: bubble,
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: bubble,
    );
  }
}
