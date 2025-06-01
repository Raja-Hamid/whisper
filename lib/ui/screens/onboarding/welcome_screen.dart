import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/widgets/background_gradient.dart';
import 'package:whisper/ui/widgets/rounded_button.dart';
import 'package:get/get.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundGradient(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    CircleAvatar(
                      backgroundImage:
                      const AssetImage('assets/images/logo.png'),
                      backgroundColor: Colors.transparent,
                      radius: 150.r,
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
                      height: 25.h,
                    ),
                    Text(
                      'Welcome! Join us and remember,\neveryone is but a whisper away from you.',
                      style: TextStyle(color: Colors.white, fontSize: 17.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35.h),
                // child: RoundedButton(
                //   title: 'Start Chatting',
                //   type: RoundedButtonType.welcomeButtonGradient,
                //   onPressed: () {
                //     Get.toNamed(AppPages.signInScreen);
                //   },
                // ),
                child: RoundedButton(
                  title: 'Get Started',
                  onPressed: () {
                    Get.toNamed(AppPages.signInScreen);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
