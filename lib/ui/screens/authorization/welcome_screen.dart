import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/widgets/rounded_button.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 0.h, top: 175.h),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      backgroundColor: Colors.transparent,
                      radius: 150,
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Text(
                    'Whisper',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 45.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Welcome! Join us and remember,\neveryone is but a whisper away from you.',
                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
            ),
            RoundedButton(
              title: 'Get Started',
              type: RoundedButtonType.primaryButtonGradient,
              onPressed: () {
                Get.toNamed(AppPages.signInScreen);
              },
            ),
            SizedBox(
              height: 40.w,
            ),
          ],
        ),
      ),
    );
  }
}
