import 'package:flutter/material.dart';
import 'features/screens/auth/onboarding.dart';

void main() {
  runApp(MaterialApp(
    scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
    home: const Onboarding()));
}
