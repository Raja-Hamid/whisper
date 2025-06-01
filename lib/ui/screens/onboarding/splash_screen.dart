import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/widgets/background_gradient.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 2500));
      final isAuthenticated = Get.find<AuthController>().isAuthenticated;
      if (isAuthenticated) {
        Get.offAllNamed(AppPages.chatsListScreen);
      } else {
        Get.offAllNamed(AppPages.welcomeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/logo.png'),
              backgroundColor: Colors.transparent,
              radius: 150.r,
            ),
            SizedBox(
              height: 35.h,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFF8F8F8).withAlpha(128),
              ),
              strokeWidth: 4.5,
              backgroundColor: CustomColors.white.withAlpha(
                (0.25 * 255).round(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
