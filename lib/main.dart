import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'features/screens/auth/onboarding.dart';
import 'package:mizania_proj/features/screens/auth/splash_screen.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/features/screens/main_navigation_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eaoqbouxgkutrkrtjacb.supabase.co',
    publishableKey: 'sb_publishable_0bpLfrk24_WWWZJeMsC1oQ_EwcoR7ZS',
  );

  supabase.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    if (session == null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Onboarding()),
        (route) => false,
      );
    } else {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  });

  final appState = AppState();

  runApp(
    AppStateScope(
      appState: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
        home: const SplashScreen(),
      ),
    ),
  );
}
