import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class EditMessageDialog extends StatelessWidget {
  final String initialText;
  final void Function(String newText) onSave;

  const EditMessageDialog({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialText);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: const Text('Edit Message'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter new message',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newText = controller.text.trim();
            if (newText.isNotEmpty && newText != initialText) {
              onSave(newText);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text('Save', style: TextStyle(color: CustomColors.white),),
        ),
      ],
    );
  }
}
