import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final user = _authController.user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75.h,
        iconTheme: IconThemeData(color: CustomColors.white, size: 25.sp),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 100.h),
          padding: EdgeInsets.fromLTRB(10.0.w, 25.0.h, 10.0.w, 25.0.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withAlpha((0.5 * 255).round()),
              ],
              stops: const [0, 0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.r),
              topRight: Radius.circular(40.0.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 45.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45.r,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'Raja Hamid',
                  style: TextStyle(
                      color: CustomColors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'rajahamidrazzaq24@gmail.com',
                  style: TextStyle(
                    color: CustomColors.black.withAlpha((0.6 * 255).round()),
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildProfileOption(
                        Icons.settings,
                        "Settings",
                      ),
                      _buildProfileOption(
                        Icons.lock,
                        "Privacy",
                      ),
                      _buildProfileOption(Icons.help_outline, "Help & Support"),
                      _buildProfileOption(Icons.logout, "Logout", onTap: () {
                        _authController.signOut();
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title,
      {VoidCallback? onTap}) {
    return ListTile(
        leading: Icon(icon, color: CustomColors.black),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: CustomColors.black,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 18.sp, color: CustomColors.black),
        onTap: onTap);
  }
}
