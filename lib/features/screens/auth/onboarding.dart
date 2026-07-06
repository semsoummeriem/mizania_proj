import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import 'dart:async';
import '../../../core/constants/colors.dart';
import 'package:mizania_proj/features/screens/auth/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to the next screen after 7 seconds
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= onboardingData.length) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          ); // goes to login page after the last onboarding screen
          return;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  List<Map<String, String>> onboardingData = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          // Handle page change if needed
          setState(() {
            // Update state if necessary
            currentIndex = index;
          });
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return AppBackground(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        onboardingData[index]['image']!,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Text(
                        onboardingData[index]['title']!,
                        style: AppStyles.bigtextstyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        onboardingData[index]['description']!,
                        style: AppStyles.smalltextstyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(onboardingData.length, (
                        dotIndex,
                      ) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 24,
                          ),
                          width: currentIndex == dotIndex ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex
                                ? AppColors.dotColor
                                : AppColors.smalltextColor,
                            //borderRadius: BorderRadius.circular(4),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
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
