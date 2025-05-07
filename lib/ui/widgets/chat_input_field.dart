import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController? messageController;
  final VoidCallback onTap;
  const ChatInputField(
      {super.key, required this.messageController, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
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
            onTap: onTap,
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: CustomColors.primaryColor1,
              child: Icon(Icons.send, color: CustomColors.white),
            ),
          ),
        ],
      ),
    );
  }
}