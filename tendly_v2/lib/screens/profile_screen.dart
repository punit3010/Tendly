import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: TendlyColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Column(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(
                        color: TendlyColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('P', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 24,
                          fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Punit Thakur', style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18,
                      fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 2),
                    const Text('Parent account', style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12,
                      color: TendlyColors.primaryLight)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel(text: 'My children'),
                    const SizedBox(height: 8),
                    _ProfileRow(
                      icon: Icons.person_outline,
                      iconBg: TendlyColors.primaryMist,
                      iconColor: TendlyColors.primary,
                      title: 'Aria',
                      subtitle: '4 years old · Active profile',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _DashedRow(
                      icon: Icons.add,
                      title: 'Add another child',
                      subtitle: 'Up to 3 profiles on Pro',
                      onTap: () => Navigator.pushNamed(context, '/paywall'),
                    ),
                    const SizedBox(height: 20),
                    const _SectionLabel(text: 'Subscription'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/paywall'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: TendlyColors.primaryMist,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: TendlyColors.primaryLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: TendlyColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.workspace_premium_outlined,
                                color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Text('Tendly Pro', style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: TendlyColors.primaryDeep)),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: TendlyColors.primary,
                                        borderRadius: BorderRadius.circular(10)),
                                      child: const Text('5 days left',
                                        style: TextStyle(fontFamily: 'Poppins',
                                          fontSize: 9, fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                    ),
                                  ]),
                                  const Text('Tap to manage subscription',
                                    style: TextStyle(fontFamily: 'Poppins',
                                      fontSize: 11, color: TendlyColors.primaryDark)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                              color: TendlyColors.primaryLight),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _SectionLabel(text: 'Account'),
                    const SizedBox(height: 8),
                    _ProfileRow(
                      icon: Icons.notifications_outlined,
                      iconBg: TendlyColors.primaryMist,
                      iconColor: TendlyColors.primary,
                      title: 'Notifications',
                      subtitle: 'Bedtime reminders, daily tips',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _ProfileRow(
                      icon: Icons.language_outlined,
                      iconBg: TendlyColors.primaryMist,
                      iconColor: TendlyColors.primary,
                      title: 'Language',
                      subtitle: 'English (US)',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _ProfileRow(
                      icon: Icons.privacy_tip_outlined,
                      iconBg: TendlyColors.primaryMist,
                      iconColor: TendlyColors.primary,
                      title: 'Privacy & data',
                      subtitle: 'Manage your data',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _ProfileRow(
                      icon: Icons.logout,
                      iconBg: const Color(0xFFFCEBEB),
                      iconColor: Colors.redAccent,
                      title: 'Sign out',
                      subtitle: '',
                      onTap: () => Navigator.pushReplacementNamed(
                        context, '/signin'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text('Tendly v1.0.0',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 11, color: TendlyColors.primaryLight)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: TendlyColors.primary,
        unselectedItemColor: TendlyColors.primaryLight,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins',
          fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins',
          fontSize: 10),
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 1) Navigator.pushReplacementNamed(context, '/story');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined),
            activeIcon: Icon(Icons.auto_stories), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
      fontWeight: FontWeight.w500, color: TendlyColors.primaryDark,
      letterSpacing: 0.5));
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final VoidCallback onTap;
  const _ProfileRow({required this.icon, required this.iconBg,
    required this.iconColor, required this.title, required this.subtitle,
    required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TendlyColors.border)),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: iconBg,
            borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontFamily: 'Poppins',
              fontSize: 13, fontWeight: FontWeight.w500,
              color: TendlyColors.primaryDeep)),
            if (subtitle.isNotEmpty) Text(subtitle,
              style: const TextStyle(fontFamily: 'Poppins',
                fontSize: 11, color: TendlyColors.primaryDark)),
          ])),
        const Icon(Icons.chevron_right, color: TendlyColors.primaryLight,
          size: 18),
      ]),
    ),
  );
}

class _DashedRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _DashedRow({required this.icon, required this.title,
    required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TendlyColors.border,
          style: BorderStyle.solid)),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: TendlyColors.primaryMist,
            borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: TendlyColors.primary, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontFamily: 'Poppins',
              fontSize: 13, fontWeight: FontWeight.w500,
              color: TendlyColors.primary)),
            Text(subtitle, style: const TextStyle(fontFamily: 'Poppins',
              fontSize: 11, color: TendlyColors.primaryDark)),
          ])),
      ]),
    ),
  );
}
