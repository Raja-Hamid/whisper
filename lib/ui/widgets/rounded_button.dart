import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  const RoundedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFFF6A3D),
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: CustomColors.white,
              fontSize: fontSize,
              fontWeight: fontWeight),
        ),
      ),
    );
  }
}
