import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/validators.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/widgets/authentication_footer.dart';
import 'package:whisper/ui/widgets/custom_text_field.dart';
import 'package:whisper/ui/widgets/rounded_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 150.h),
          padding: EdgeInsets.symmetric(horizontal: 25.w),
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    'Password Recovery',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final regExp = RegExp(kEmailRegex);
                    if (!regExp.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25.h,
                ),
                RoundedButton(
                  title: 'Send Code',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.resetPassword(
                          email: _emailController.text.trim());
                    }
                  },
                  type: RoundedButtonType.primaryButtonGradient,
                ),
                AuthenticationFooter(
                  leadingText: 'Don\'t have an account? ',
                  actionText: 'Sign Up',
                  onTapAction: () => Get.toNamed(AppPages.signUpScreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
