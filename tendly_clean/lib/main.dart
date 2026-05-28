import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/payment_service.dart';
import 'screens/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'screens/story_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/paywall_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Init all services in parallel
  await Future.wait([
    AuthService.initialize(),
    PaymentService.initialize(),
  ]);

  runApp(const TendlyApp());
}

class TendlyApp extends StatelessWidget {
  const TendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendly',
      debugShowCheckedModeBanner: false,
      theme: TendlyTheme.theme,
      initialRoute: AuthService.isLoggedIn ? '/home' : '/signin',
      routes: {
        '/signin':  (_) => const SignInScreen(),
        '/home':    (_) => const HomeScreen(),
        '/story':   (_) => const StoryScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/paywall': (_) => const PaywallScreen(),
      },
    );
  }
}
