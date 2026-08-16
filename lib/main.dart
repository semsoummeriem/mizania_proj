import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'features/screens/auth/onboarding.dart';
import 'package:mizania_proj/features/screens/auth/splash_screen.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/features/screens/main_navigation_screen.dart';
import 'package:mizania_proj/core/constants/colors.dart';

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

  runApp(AppStateScope(appState: appState, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppState _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateScope.of(context);
    _appState.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundlightColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.dotColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgrounddarkColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.dotColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
