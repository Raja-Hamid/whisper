import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';

class ChatsListAppBar extends StatelessWidget {
  const ChatsListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 10.h),
      child: Row(
        children: [
          Text(
            'Whisper',
            style: TextStyle(
                color: CustomColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 35.sp,
                fontFamily: 'PlayFairDisplay'),
          ),
          const Spacer(),
          GestureDetector(
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: () async {
              Get.find<AuthController>().signOut();
            },
          ),
          SizedBox(
            width: 10.w,
          ),
          CircleAvatar(
            radius: 20.r,
          ),
        ],
      ),
    );
  }
}
