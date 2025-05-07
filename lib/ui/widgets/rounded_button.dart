import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

enum RoundedButtonType { primaryButtonGradient, secondaryButtonGradient, textGradient }

class RoundedButton extends StatelessWidget {
  final String title;
  final RoundedButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;

  const RoundedButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.type = RoundedButtonType.textGradient,
      this.fontWeight = FontWeight.w700,
      this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: type == RoundedButtonType.secondaryButtonGradient
                ? CustomColors.secondaryGradient
                : CustomColors.primaryButtonGradient,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: type == RoundedButtonType.primaryButtonGradient ||
                  type == RoundedButtonType.secondaryButtonGradient
              ? const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.5,
                      offset: Offset(0, 0.5))
                ]
              : null),
      child: MaterialButton(
        onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: CustomColors.primaryColor1,
        minWidth: double.maxFinite,
        elevation: type == RoundedButtonType.primaryButtonGradient ||
                type == RoundedButtonType.secondaryButtonGradient
            ? 0
            : 1,
        color: type == RoundedButtonType.primaryButtonGradient ||
                type == RoundedButtonType.secondaryButtonGradient
            ? Colors.transparent
            : CustomColors.white,
        child: type == RoundedButtonType.primaryButtonGradient ||
                type == RoundedButtonType.secondaryButtonGradient
            ? Text(
                title,
                style: TextStyle(
                    color: CustomColors.white,
                    fontSize: fontSize,
                    fontWeight: fontWeight),
              )
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                          colors: CustomColors.primaryButtonGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      .createShader(
                    Rect.fromLTRB(0, 0, bounds.height, bounds.width),
                  );
                },
                child: Text(
                  title,
                  style: TextStyle(
                    color: CustomColors.primaryColor1,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
      ),
    );
  }
}