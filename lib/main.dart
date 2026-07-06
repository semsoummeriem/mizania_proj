import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'features/screens/auth/onboarding.dart';

void main() {
  final appState = AppState();

  runApp(
    AppStateScope(
      appState: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
        home: const Onboarding(),
      ),
    ),
  );
}