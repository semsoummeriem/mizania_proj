import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'package:mizania_proj/features/screens/auth/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eaoqbouxgkutrkrtjacb.supabase.co',
    publishableKey: 'sb_publishable_0bpLfrk24_WWWZJeMsC1oQ_EwcoR7ZS',
  );

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
