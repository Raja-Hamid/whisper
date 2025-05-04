import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class AuthenticationFooter extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTapAction;
  const AuthenticationFooter({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: leadingText,
              style: TextStyle(color: CustomColors.black, fontSize: 14.sp),
            ),
            TextSpan(
              text: actionText,
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTapAction,
            ),
          ],
        ),
      ),
    );
  }
}
