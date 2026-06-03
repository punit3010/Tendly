import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onUpgrade;
  const ProfileScreen({super.key, required this.onUpgrade});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifStory = true;
  bool _notifMeal = true;
  bool _notifHealth = false;
  bool _notifCircles = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final top = MediaQuery.of(context).padding.top;

    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _ProfileHeader(
        state: state, onUpgrade: widget.onUpgrade, top: top)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        sliver: SliverList(delegate: SliverChildListDelegate([
          // Children
          _SectionLabel('Your children'),
          const SizedBox(height: 10),
          ...state.children.map((c) => _ChildRow(child: c)),
          _AddChildRow(),
          const SizedBox(height: 24),

          // Account
          _SectionLabel('Account'),
          const SizedBox(height: 10),
          _SettingsCard(children: [
            _SettingsRow(icon: '👤', title: 'Parent name',
                subtitle: state.parentName, onTap: () => showTToast(context, 'Edit name')),
            _SettingsRow(icon: '✉️', title: 'Email',
                subtitle: 'punitjrt@gmail.com', onTap: () => showTToast(context, 'Change email')),
            _SettingsRow(icon: '👑', title: 'Subscription',
                subtitle: 'Free plan · Upgrade to Pro',
                iconBg: TColors.terracottaSoft,
                onTap: widget.onUpgrade),
          ]),
          const SizedBox(height: 24),

          // Notifications
          _SectionLabel('Notifications'),
          const SizedBox(height: 10),
          _SettingsCard(children: [
            _ToggleRow(icon: '🌙', title: 'Bedtime story reminder',
                subtitle: '8:00 PM daily',
                value: _notifStory, onChanged: (v) => setState(() => _notifStory = v)),
            _ToggleRow(icon: '🍳', title: 'Meal planning nudge',
                subtitle: 'Sunday mornings',
                value: _notifMeal, onChanged: (v) => setState(() => _notifMeal = v)),
            _ToggleRow(icon: '🌱', title: 'Health reminders',
                subtitle: 'Upcoming vaccinations & checkups',
                value: _notifHealth, onChanged: (v) => setState(() => _notifHealth = v)),
            _ToggleRow(icon: '🤝', title: 'Circle activity',
                subtitle: 'New posts & playdate updates',
                value: _notifCircles, onChanged: (v) => setState(() => _notifCircles = v)),
          ]),
          const SizedBox(height: 24),

          // App
          _SectionLabel('App'),
          const SizedBox(height: 10),
          _SettingsCard(children: [
            _SettingsRow(icon: '🔒', title: 'Privacy & data',
                subtitle: 'COPPA compliant · your data, always',
                onTap: () => showTToast(context, 'Privacy policy')),
            _SettingsRow(icon: '📄', title: 'Terms of service',
                onTap: () => showTToast(context, 'Terms of service')),
            _SettingsRow(icon: '⭐', title: 'Rate Tendly',
                subtitle: 'Enjoying the app? Leave a review',
                onTap: () => showTToast(context, 'Thank you!')),
            _SettingsRow(icon: '🚪', title: 'Sign out',
                titleColor: TColors.error, iconBg: const Color(0xFFFEE2E2),
                onTap: () => showTToast(context, 'Signed out')),
          ]),
          const SizedBox(height: 16),
          Center(child: Text('Tendly v1.0 · Made with 🌿 for families everywhere',
              style: TText.body(12, color: TColors.textMuted))),
        ])),
      ),
    ]);
  }
}

class _ProfileHeader extends StatelessWidget {
  final AppState state;
  final VoidCallback onUpgrade;
  final double top;
  const _ProfileHeader({required this.state, required this.onUpgrade, required this.top});

  @override
  Widget build(BuildContext context) => Container(
    color: TColors.forest,
    child: Stack(children: [
      const TopoBackground(),
      Padding(
        padding: EdgeInsets.fromLTRB(
            THeader.sidePad, top + 12, THeader.sidePad, THeader.roomBotPad),
        child: Column(children: [
          Container(
            width: 76, height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 3),
            ),
            child: Center(child: Text(
              state.children.isNotEmpty ? state.children[0].emoji : '👤',
              style: const TextStyle(fontSize: 34),
            )),
          ),
          const SizedBox(height: 14),
          Text(state.parentName, style: TText.display(24, color: Colors.white)),
          const SizedBox(height: 4),
          Text('Member since June 2025',
              style: TText.body(12, color: Colors.white.withOpacity(0.45))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onUpgrade,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: TColors.terracotta, borderRadius: BorderRadius.circular(18)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('👑', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Text('Upgrade to Pro',
                    style: TText.body(12, weight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ),
        ]),
      ),
    ]),
  );
}

// ── Helpers ──────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Text(label.toUpperCase(), style: TText.eyebrow()),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: TColors.surface,
      borderRadius: TRadius.lg,
      border: Border.all(color: TColors.border),
      boxShadow: TShadow.sm,
    ),
    child: Column(children: children.asMap().entries.map((e) => Column(children: [
      e.value,
      if (e.key < children.length - 1) const Divider(height: 1),
    ])).toList()),
  );
}

class _SettingsRow extends StatelessWidget {
  final String icon, title;
  final String? subtitle;
  final Color? iconBg, titleColor;
  final VoidCallback onTap;
  const _SettingsRow({required this.icon, required this.title, this.subtitle,
      this.iconBg, this.titleColor, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
              color: iconBg ?? TColors.tealSoft, borderRadius: TRadius.sm),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 17))),
        ),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TText.body(14, weight: FontWeight.w600,
              color: titleColor ?? TColors.textPrimary)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: TText.body(12, color: TColors.textMuted)),
          ],
        ])),
        const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: TColors.textMuted),
      ]),
    ),
  );
}

class _ToggleRow extends StatelessWidget {
  final String icon, title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.title, required this.subtitle,
      required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    child: Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(color: TColors.tealSoft, borderRadius: TRadius.sm),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 17))),
      ),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TText.body(14, weight: FontWeight.w600, color: TColors.textPrimary)),
        const SizedBox(height: 2),
        Text(subtitle, style: TText.body(12, color: TColors.textMuted)),
      ])),
      TToggle(value: value, onChanged: onChanged),
    ]),
  );
}

class _ChildRow extends StatelessWidget {
  final dynamic child;
  const _ChildRow({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: TColors.surface, borderRadius: TRadius.lg,
        border: Border.all(color: TColors.border), boxShadow: TShadow.sm),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(color: TColors.tealSoft, shape: BoxShape.circle),
            child: Center(child: Text(child.emoji, style: const TextStyle(fontSize: 20)))),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(child.name, style: TText.body(15, weight: FontWeight.w700, color: TColors.textPrimary)),
          Text(child.ageBand, style: TText.body(12, color: TColors.textSecondary)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: TColors.surface2, borderRadius: TRadius.sm),
          child: Text('Edit', style: TText.body(12, weight: FontWeight.w600, color: TColors.textSecondary)),
        ),
      ]),
    ),
  );
}

class _AddChildRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: TColors.surface, borderRadius: TRadius.lg,
        border: Border.all(color: TColors.border, width: 2, style: BorderStyle.solid)),
    child: GestureDetector(
      onTap: () => showTToast(context, 'Add another child — coming soon'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TColors.border, width: 2, style: BorderStyle.solid)),
            child: Center(child: Text('+', style: TText.body(18, color: TColors.textMuted))),
          ),
          const SizedBox(width: 13),
          Text('Add another child',
              style: TText.body(14, weight: FontWeight.w600, color: TColors.textSecondary)),
        ]),
      ),
    ),
  );
}

