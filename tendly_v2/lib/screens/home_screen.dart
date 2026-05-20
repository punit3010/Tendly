import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/tendly_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: TendlyColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Good evening, Punit',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                            const SizedBox(height: 2),
                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: TendlyColors.primaryLight,
                              )),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TendlyColors.primaryDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_outlined,
                            color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Child chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TendlyColors.primaryDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              color: TendlyColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('A',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Aria · 4 yrs',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bedtime story card
                    _TodayCard(
                      tag: "Tonight's story",
                      tagColor: TendlyColors.primaryLight,
                      tagTextColor: TendlyColors.primaryDeep,
                      bgColor: TendlyColors.primaryMist,
                      borderColor: TendlyColors.primaryLight,
                      title: 'The Dragon Who Lost Her Wings',
                      body: 'A personalized bedtime story for Aria — adventure theme, age 4.',
                      actionLabel: 'Read now',
                      actionColor: TendlyColors.primary,
                      icon: Icons.auto_stories_outlined,
                      onTap: () => Navigator.pushNamed(context, '/story'),
                    ),

                    const SizedBox(height: 12),

                    // Daily tip card
                    _TodayCard(
                      tag: 'Daily tip · Nutrition',
                      tagColor: const Color(0xFFFAC775),
                      tagTextColor: const Color(0xFF633806),
                      bgColor: const Color(0xFFFAEEDA),
                      borderColor: const Color(0xFFFAC775),
                      title: 'Iron-rich foods at age 4',
                      body: 'Lentils, spinach, and fortified cereals boost focus and energy.',
                      actionLabel: 'Learn more',
                      actionColor: TendlyColors.amber,
                      icon: Icons.local_dining_outlined,
                      onTap: () {},
                    ),

                    const SizedBox(height: 20),

                    // Quick access
                    const Text('Quick access',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: TendlyColors.primaryDeep,
                      )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _QuickBtn(
                          icon: Icons.bedtime_outlined,
                          label: 'Stories',
                          onTap: () => Navigator.pushNamed(context, '/story'),
                        ),
                        const SizedBox(width: 10),
                        _QuickBtn(
                          icon: Icons.restaurant_outlined,
                          label: 'Nutrition',
                          onTap: () {},
                        ),
                        const SizedBox(width: 10),
                        _QuickBtn(
                          icon: Icons.favorite_border_outlined,
                          label: 'Health',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom nav ──────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: TendlyColors.primary,
        unselectedItemColor: TendlyColors.primaryLight,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins', fontSize: 10),
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, '/story');
          if (i == 2) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            activeIcon: Icon(Icons.auto_stories),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${days[now.weekday - 1]} · ${months[now.month - 1]} ${now.day}';
  }
}

class _TodayCard extends StatelessWidget {
  final String tag, title, body, actionLabel;
  final Color tagColor, tagTextColor, bgColor, borderColor, actionColor;
  final IconData icon;
  final VoidCallback onTap;

  const _TodayCard({
    required this.tag, required this.title, required this.body,
    required this.actionLabel, required this.tagColor,
    required this.tagTextColor, required this.bgColor,
    required this.borderColor, required this.actionColor,
    required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: tagTextColor,
                )),
            ),
            const SizedBox(height: 8),
            Text(title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tagTextColor,
              )),
            const SizedBox(height: 4),
            Text(body,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: tagTextColor.withOpacity(0.8),
                height: 1.5,
              )),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, size: 14, color: actionColor),
                const SizedBox(width: 4),
                Text(actionLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: actionColor,
                  )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickBtn({
    required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TendlyColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: TendlyColors.primary, size: 22),
              const SizedBox(height: 5),
              Text(label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: TendlyColors.primaryDark,
                )),
            ],
          ),
        ),
      ),
    );
  }
}
