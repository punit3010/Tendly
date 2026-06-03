import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/app_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stories_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/health_screen.dart';
import 'screens/circles_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/paywall_screen.dart';
import 'widgets/shared_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  final state = AppState();
  await state.load();

  runApp(
    ChangeNotifierProvider.value(value: state, child: const TendlyApp()),
  );
}

class TendlyApp extends StatelessWidget {
  const TendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _AppEntry(),
    );
  }
}

class _AppEntry extends StatelessWidget {
  const _AppEntry();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.isOnboarded) {
      return OnboardingScreen(
        onComplete: () {
          // State already updated — widget rebuilds automatically
        },
      );
    }
    return const MainShell();
  }
}

// ─── MAIN SHELL WITH BOTTOM NAV ──────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  bool _showPaywall = false;

  static const _navItems = [
    _NavItem('🏡', 'The Nest'),
    _NavItem('📖', 'Stories'),
    _NavItem('🌱', 'Health'),
    _NavItem('🤝', 'Circles'),
    _NavItem('👤', 'Profile'),
  ];

  void _navigate(int index) {
    if (index == 5) { // paywall shortcut
      setState(() => _showPaywall = true);
      return;
    }
    setState(() => _tab = index);
  }

  Widget _buildBody() {
    if (_showPaywall) {
      return PaywallScreen(onClose: () => setState(() => _showPaywall = false));
    }
    switch (_tab) {
      case 0: return HomeScreen(onNavigate: _navigate);
      case 1: return StoriesScreen(onBack: () => setState(() => _tab = 0));
      case 2: return HealthScreen(onBack: () => setState(() => _tab = 0));
      case 3: return const CirclesScreen();
      case 4: return ProfileScreen(onUpgrade: () => setState(() => _showPaywall = true));
      default: return HomeScreen(onNavigate: _navigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _tab == 1 ? const Color(0xFF071A12)
          : _tab == 2 ? TColors.bg
          : TColors.bg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_showPaywall ? 'paywall' : _tab),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _showPaywall ? null : _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      decoration: BoxDecoration(
        color: TColors.surface,
        border: const Border(top: BorderSide(color: TColors.border)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F0A3D2E), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: _navItems.asMap().entries.map((e) {
              final active = e.key == _tab && !_showPaywall;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() { _tab = e.key; _showPaywall = false; }),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e.value.icon, style: const TextStyle(fontSize: 21)),
                      const SizedBox(height: 3),
                      Text(e.value.label,
                          style: TText.body(10, weight: FontWeight.w600,
                              color: active ? TColors.forest : TColors.textMuted)),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: active ? 4 : 0,
                        height: active ? 4 : 0,
                        decoration: const BoxDecoration(
                            color: TColors.forest, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon, label;
  const _NavItem(this.icon, this.label);
}
