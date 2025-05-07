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
import 'package:whisper/ui/widgets/social_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;
  bool rememberPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 125.h),
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 25.w),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        150.h -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hey there,',
                              style: TextStyle(
                                fontSize: 20.sp,
                              ),
                            ),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
                        CustomTextField(
                            hintText: 'Password',
                            icon: Icons.lock,
                            obscureText: !showPassword,
                            suffixIcon: showPassword == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            onIconTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            }),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  checkColor: CustomColors.white,
                                  activeColor: Colors.blueAccent,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'Remember Me',
                                  style: TextStyle(color: CustomColors.black),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: CustomColors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              onTap: () {
                                Get.toNamed(AppPages.forgotPasswordScreen);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        RoundedButton(
                          title: 'Sign In',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _authController.signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                          type: RoundedButtonType.primaryButtonGradient,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: CustomColors.grey
                                    .withAlpha((0.5 * 255).round()),
                                thickness: 1.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 0.h),
                              child: Text(
                                'Sign in with',
                                style: TextStyle(
                                  color: CustomColors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: CustomColors.grey
                                    .withAlpha((0.5 * 255).round()),
                                thickness: 1.h,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        const SocialBar(),
                        const Spacer(),
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
            ),
          ),
        ),
      ),
    );
  }
}
