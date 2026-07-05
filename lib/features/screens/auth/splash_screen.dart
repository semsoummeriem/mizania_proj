import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/widgets/dot.dart';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.2)),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 100, color: AppColors.dotColor, opacity: 0.2)),
          ),
          Positioned(
            bottom: -40,
            left: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.2)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 150, height: 150),
                Image.asset('assets/name.png', width: 1000, height: 100),
                SizedBox(height: 6),
                Text(
                  'Suivez. Analysez. Économisez',
                  style: AppStyles.smalltextstyle,
                ),
                SizedBox(height: 60),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 200,
                    height: 10,
                    child: LinearProgressIndicator(
                      
                     // strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.dotColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
