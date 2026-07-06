import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'features/screens/main_navigation_screen.dart';

void main() {
  // On crée UNE SEULE instance de AppState, partagée par toute l'application.
  final appState = AppState();

  runApp(
    AppStateScope(
      appState: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainNavigationScreen(),
      ),
    ),
  );
}