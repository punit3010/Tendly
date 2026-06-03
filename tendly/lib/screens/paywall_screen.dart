import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onClose;
  const PaywallScreen({super.key, required this.onClose});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _plan = 'annual';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: TColors.bg,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _PaywallHeader(top: top)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Perks
            ..._perks.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: TColors.tealSoft, borderRadius: TRadius.sm),
                  child: Center(child: Text(p['icon']!, style: const TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['title']!, style: TText.body(14, weight: FontWeight.w600, color: TColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(p['desc']!, style: TText.body(12, color: TColors.textSecondary)),
                ])),
              ]),
            )),
            const SizedBox(height: 28),
            // Plan cards
            _PlanCard(
              name: 'Annual',
              price: '\$4.99',
              period: '/ month',
              desc: '\$59.99 billed once a year · 7-day free trial',
              selected: _plan == 'annual',
              badge: 'Best value · save 40%',
              onTap: () => setState(() => _plan = 'annual'),
            ),
            const SizedBox(height: 9),
            _PlanCard(
              name: 'Monthly',
              price: '\$8.99',
              period: '/ month',
              desc: 'Billed monthly · cancel anytime',
              selected: _plan == 'monthly',
              onTap: () => setState(() => _plan = 'monthly'),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showTToast(context, 'Starting your 7-day free trial 🎉'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.forest,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const RoundedRectangleBorder(borderRadius: TRadius.md),
                ),
                child: Text('Start 7-day free trial',
                    style: TText.body(15, weight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 11),
            Text('No charge today. Cancel anytime before trial ends.\nTendly is always ad-free.',
                textAlign: TextAlign.center,
                style: TText.body(11, color: TColors.textMuted, height: 1.5)),
            const SizedBox(height: 10),
            Center(child: GestureDetector(
              onTap: widget.onClose,
              child: Text('Not now', style: TText.body(13, color: TColors.textMuted)),
            )),
          ])),
        ),
      ]),
    );
  }
}

class _PaywallHeader extends StatelessWidget {
  final double top;
  const _PaywallHeader({required this.top});

  @override
  Widget build(BuildContext context) => Container(
    color: TColors.forest,
    child: Stack(children: [
      const TopoBackground(),
      Padding(
        padding: EdgeInsets.fromLTRB(THeader.sidePad, top + 12, THeader.sidePad, 28),
        child: Column(children: [
          const Text('👑', style: TextStyle(fontSize: 42)),
          const SizedBox(height: 14),
          RichText(textAlign: TextAlign.center, text: TextSpan(
            style: TText.display(29, color: Colors.white),
            children: [
              const TextSpan(text: 'Unlock '),
              TextSpan(text: 'Tendly Pro',
                  style: TText.display(29, style: FontStyle.italic, color: TColors.mintAccent)),
            ],
          )),
          const SizedBox(height: 9),
          Text('Everything your family needs, every day.\nNo ads, ever.',
              textAlign: TextAlign.center,
              style: TText.body(14, color: Colors.white.withOpacity(0.55), height: 1.5)),
        ]),
      ),
    ]),
  );
}

class _PlanCard extends StatelessWidget {
  final String name, price, period, desc;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;
  const _PlanCard({required this.name, required this.price, required this.period,
      required this.desc, required this.selected, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: selected ? TColors.tealSoft : TColors.surface,
        borderRadius: TRadius.md,
        border: Border.all(
            color: selected ? TColors.forest : TColors.border, width: selected ? 2 : 1),
      ),
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (badge != null) const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
              children: [
            Text(name, style: TText.body(14, weight: FontWeight.w700, color: TColors.textPrimary)),
            const Spacer(),
            Text(price, style: TText.display(20, color: TColors.forest)),
            const SizedBox(width: 3),
            Text(period, style: TText.body(11, color: TColors.textMuted)),
          ]),
          const SizedBox(height: 3),
          Text(desc, style: TText.body(12, color: TColors.textSecondary)),
        ]),
        if (badge != null)
          Positioned(top: -9, left: 0, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
                color: TColors.terracotta, borderRadius: BorderRadius.circular(9)),
            child: Text(badge!, style: TText.body(9, weight: FontWeight.w800,
                color: Colors.white)),
          )),
      ]),
    ),
  );
}

const _perks = [
  {'icon': '✨', 'title': 'Unlimited AI stories', 'desc': 'New personalised tales every night, never repeated'},
  {'icon': '🎨', 'title': 'Full Activity Center', 'desc': 'Printable coloring sheets, crafts & scavenger hunts'},
  {'icon': '🤝', 'title': 'Unlimited Circles', 'desc': 'School, family, neighborhood — all private'},
  {'icon': '📅', 'title': 'Calendar sync & reminders', 'desc': 'Health alerts, playdate scheduling, routine nudges'},
];
