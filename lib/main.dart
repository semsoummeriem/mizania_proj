import 'package:flutter/material.dart';
import 'features/screens/profile/profile_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    ),
  );
}