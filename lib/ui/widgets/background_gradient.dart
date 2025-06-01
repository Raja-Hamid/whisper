import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  const BackgroundGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1215),
                Color(0xFF131D22),
                Color(0xFF1F2C30),
                Color(0xFF422319),
                Color(0xFFFF6A3D),
              ],
              stops: [
                0.00,
                0.25,
                0.50,
                0.75,
                1.00,
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-1.0, 1.0),
              radius: 1.2,
              colors: [
                Color(0xFFFF6A3D),
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF131D22).withAlpha((0.80 * 255).round()),
                const Color(0xFF0B1215).withAlpha((0.80 * 255).round()),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
