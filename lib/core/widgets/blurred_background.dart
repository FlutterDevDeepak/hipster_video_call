import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hipster/core/constants/app_colors.dart';

class BlueAbstractBackground extends StatelessWidget {
  final Widget child;
  const BlueAbstractBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [
                // Color.fromARGB(255, 11, 25, 72), Color.fromARGB(255, 5, 78, 215)],
              colors: [AppColor.lightCyanColor, AppColor.cyanColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: -80,
          left: -50,
          child: _BlurredCircle(
            diameter: 200,
            color: Colors.orange.withValues(alpha: .3),
            // color: Colors.orange.withValues(alpha: .3),
          ),
        ),

        // Soft abstract shape 2
        Positioned(
          bottom: -60,
          right: -40,
          child: _BlurredCircle(
            diameter: 250,
            color: Colors.orangeAccent.withValues(alpha: 0.4),
          ),
        ),

        // Soft abstract shape 3
        Positioned(
          top: 100,
          right: 50,
          child: _BlurredCircle(
            diameter: 100,
            color: Colors.deepOrange.withValues(alpha: 0.1),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(shape: BoxShape.circle),
          ),
        ),
        child,
      ],
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const _BlurredCircle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
