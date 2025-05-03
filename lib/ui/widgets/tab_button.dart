import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisper/constants/colors.dart';

class TabButton extends StatelessWidget {
  final String icon;
  final String selectedIcon;
  final VoidCallback onTap;
  final bool isActive;
  const TabButton(
      {super.key,
      required this.icon,
      required this.selectedIcon,
      required this.onTap,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isActive ? selectedIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: isActive ? 8 : 12),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: CustomColors.secondaryGradient),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
