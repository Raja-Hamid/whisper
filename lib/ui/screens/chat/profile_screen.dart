import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/ui/widgets/background_gradient.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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
            fontSize: 25.sp,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomColors.white, size: 25.sp),
        toolbarHeight: kToolbarHeight,
      ),
      body: BackgroundGradient(
        child: SafeArea(
          child: Container(
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
              child: Obx(
                () {
                  final user = _authController.userModel.value;
                  if (user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        child: Text(
                          user.firstName[0],
                          style: TextStyle(fontSize: 35.sp),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                            color: CustomColors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          color:
                              CustomColors.black.withAlpha((0.6 * 255).round()),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
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
                            _buildProfileOption(
                                Icons.help_outline, "Help & Support"),
                            _buildProfileOption(Icons.logout, "Logout",
                                onTap: () {
                              _authController.signOut();
                            }),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
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
