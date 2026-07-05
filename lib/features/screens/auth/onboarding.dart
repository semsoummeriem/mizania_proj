import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/1st.png',
      'title': 'Suis tes dépenses',
      'description': 'Ajouter tes dépenses facilement chaque jour',
    },
    {
      'image': 'assets/2nd.png',
      'title': 'Gère ton budget',
      'description': 'Obtenez des rapports détaillés sur vos habitudes de dépenses.',
    },
    {
      'image': 'assets/3rd.png',
      'title': 'Reste alerté',
      'description': 'Reçoit des alertes avant de dépasser ton budget',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}