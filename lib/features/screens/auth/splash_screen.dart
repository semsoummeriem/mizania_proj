import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/widgets/dot.dart';
import 'dart:ui';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: Stack(
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 300, height: 300),
                Image.asset('assets/name.png', width: 1000, height: 100),
                SizedBox(height: 20),
                Text(
                  'Suivez. Analysez. Économisez',
                  style: AppStyles.smalltextstyle,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
