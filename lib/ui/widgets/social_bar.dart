import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialBar extends StatelessWidget {
  const SocialBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 0, horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: SvgPicture.asset(
                'assets/icons/facebook.svg',
                width: 50.w,
                height: 50.h),
          ),
          GestureDetector(
            child: SvgPicture.asset(
                'assets/icons/twitter.svg',
                width: 50.w,
                height: 50.h),
          ),
          GestureDetector(
            child: SvgPicture.asset(
                'assets/icons/google.svg',
                width: 45.w,
                height: 45.h),
          ),
          GestureDetector(
            child: SvgPicture.asset(
                'assets/icons/apple.svg',
                width: 45.w,
                height: 45.h),
          ),
        ],
      ),
    );
  }
}
