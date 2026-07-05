import "package:flutter/material.dart";
import 'dart:ui';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/widgets/dot.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.15)),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 100, color: AppColors.dotColor, opacity: 0.15)),
          ),
          Positioned(
            bottom: -40,
            left: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.15)),
          ),
          child,
        ],
      ),
    );
  }
}