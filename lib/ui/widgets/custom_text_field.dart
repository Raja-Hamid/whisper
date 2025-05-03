import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData icon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final EdgeInsets? margin;
  final String? Function(String?)? validator;
  final VoidCallback? onIconTap;
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    required this.icon,
    this.suffixIcon,
    this.margin,
    this.validator,
    this.onIconTap,
    this.suffixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: CustomColors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: CustomColors.grey,
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onIconTap,
                  child:
                      Icon(suffixIcon, color: suffixIconColor ?? CustomColors.grey),
                )
              : null,
        ),
      ),
    );
  }
}
