import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import 'dart:async';
import '../../../core/constants/colors.dart';
import 'package:mizania_proj/features/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  late Timer _timer;
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/1st.png',
      'title': 'Suis tes dépenses',
      'description': 'Ajouter tes dépenses facilement chaque jour',
    },
    {
      'image': 'assets/2nd.png',
      'title': 'Gère ton budget',
      'description':
          'Obtenez des rapports détaillés sur vos habitudes de dépenses.',
    },
    {
      'image': 'assets/3rd.png',
      'title': 'Reste alerté',
      'description': 'Reçoit des alertes avant de dépasser ton budget',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= onboardingData.length) {
          _finishOnboarding();
          return;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Future<void> _finishOnboarding() async {
    _timer.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: PageView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return AppBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        onboardingData[index]['image']!,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        onboardingData[index]['title']!,
                        style: AppStyles.bigtextstyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        onboardingData[index]['description']!,
                        style: AppStyles.smalltextstyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(onboardingData.length, (
                        dotIndex,
                      ) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 24,
                          ),
                          width: currentIndex == dotIndex ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex
                                ? AppColors.dotColor
                                : AppColors.smalltextColor,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    // buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _finishOnboarding,
                          child: Text(
                            'Passer',
                            style: TextStyle(color: AppColors.smalltextColor),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (currentIndex < onboardingData.length - 1) {
                              _pageController.animateToPage(
                                currentIndex + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                              );
                            } else {
                              _finishOnboarding();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dotColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            currentIndex == onboardingData.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
