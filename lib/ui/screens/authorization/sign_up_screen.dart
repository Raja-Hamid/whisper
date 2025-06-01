import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/validators.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/widgets/authentication_footer.dart';
import 'package:whisper/ui/widgets/background_gradient.dart';
import 'package:whisper/ui/widgets/custom_text_field.dart';
import 'package:whisper/ui/widgets/rounded_button.dart';
import 'package:whisper/ui/widgets/social_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BackgroundGradient(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 50.h),
            padding: EdgeInsets.only(top: 25.h, left: 25.w, right: 25.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withAlpha((0.25 * 255).round()),
                ],
                stops: const [0, 0],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0.r),
                topRight: Radius.circular(40.0.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hey there,',
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Create your Account',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        CustomTextField(
                          hintText: 'First Name',
                          icon: Icons.person_rounded,
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomTextField(
                          hintText: 'Last Name',
                          icon: Icons.person_rounded,
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomTextField(
                          hintText: 'Username',
                          icon: Icons.person,
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
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
                          height: 15.h,
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
                        CustomTextField(
                          hintText: 'Confirm Password',
                          icon: Icons.lock,
                          obscureText: !showConfirmPassword,
                          suffixIcon: showConfirmPassword == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            } else if (value !=
                                _passwordController.text.trim()) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onIconTap: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        RoundedButton(
                          title: 'Sign Up',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _authController.signUp(
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                userName: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
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
                                'Sign up with',
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: AuthenticationFooter(
                    leadingText: 'Already have an account? ',
                    actionText: 'Sign In',
                    onTapAction: () => Get.toNamed(AppPages.signInScreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
