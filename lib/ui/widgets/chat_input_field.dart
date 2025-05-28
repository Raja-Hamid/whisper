import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';


class ChatInputField extends StatefulWidget {
  final TextEditingController? messageController;
  final VoidCallback onTap;
  const ChatInputField({super.key, required this.messageController, required this.onTap});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isEmojiVisible = false;

  void _toggleEmojiKeyboard() {
    if (_isEmojiVisible) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
    setState(() => _isEmojiVisible = !_isEmojiVisible);
  }

  void _onEmojiSelected(Emoji emoji) {
    final text = widget.messageController!.text;
    final selection = widget.messageController!.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji.emoji,
    );
    widget.messageController!.text = newText;
    widget.messageController!.selection = TextSelection.collapsed(
      offset: selection.start + emoji.emoji.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.emoji_emotions),
                suffixIcon: const Icon(Icons.camera_alt),
                hintText: 'Message',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 35.w,
                  vertical: 15.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: widget.onTap,
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
