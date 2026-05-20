import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/sign_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait — this is a mobile-first app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent so our teal backgrounds bleed through
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:            Colors.transparent,
    statusBarIconBrightness:   Brightness.dark,
  ));

  runApp(const TendlyApp());
}

class TendlyApp extends StatelessWidget {
  const TendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:          'Tendly',
      debugShowCheckedModeBanner: false,
      theme:          TendlyTheme.theme,
      initialRoute:   '/signin',
      routes: {
        '/signin': (_) => const SignInScreen(),
        // These will be added as we build each screen:
        // '/onboarding': (_) => const OnboardingScreen(),
        // '/home':       (_) => const HomeScreen(),
        // '/story':      (_) => const StoryScreen(),
        // '/profile':    (_) => const ProfileScreen(),
        // '/paywall':    (_) => const PaywallScreen(),
      },
    );
  }
}
