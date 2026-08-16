import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/widgets/dot.dart';
import 'dart:ui';
import 'dart:async';
import 'package:mizania_proj/features/screens/auth/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/features/screens/main_navigation_screen.dart';
import 'package:mizania_proj/features/screens/auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('onboarding_seen') ?? false;
      final session = supabase.auth.currentSession;
      if (!mounted) return;
      if (!seen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Onboarding()),
        );
      } else if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: Stack(
        children: [
          Positioned(
            top: -40,
            left: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.2),
            ),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 100, color: AppColors.dotColor, opacity: 0.2),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dot(size: 150, color: AppColors.dotColor, opacity: 0.2),
            ),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.dotColor,
                      ),
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
