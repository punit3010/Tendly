import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class HealthScreen extends StatelessWidget {
  final VoidCallback onBack;
  const HealthScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final childName = state.activeChild?.name ?? 'your child';

    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: LightScreenHeader(
        title: 'Health Garden',
        subtitle: 'Records for $childName',
        onBack: onBack,
      )),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        sliver: SliverList(delegate: SliverChildListDelegate([
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TColors.tealSoft,
              borderRadius: TRadius.md,
              border: Border.all(color: TColors.teal.withOpacity(0.2)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ℹ️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 9),
              Expanded(child: Text(
                'Tendly tracks records and sends reminders. Always consult your paediatrician for medical advice.',
                style: TText.body(13, color: TColors.forestMid, height: 1.5),
              )),
            ]),
          ),
          const SizedBox(height: 20),
          ..._healthItems.map((item) => _HealthCard(
            icon: item['icon']!,
            name: item['name']!,
            subtitle: item['sub']!,
            onTap: () => showTToast(context, item['name']!),
          )),
        ])),
      ),
    ]);
  }
}

const _healthItems = [
  {'icon': '📏', 'name': 'Growth', 'sub': 'No records yet — tap to add'},
  {'icon': '💉', 'name': 'Vaccinations', 'sub': 'Next due: check with your doctor'},
  {'icon': '🌙', 'name': 'Sleep log', 'sub': 'No records yet'},
  {'icon': '🩺', 'name': 'Doctor visits', 'sub': 'Add your last checkup'},
  {'icon': '🚨', 'name': 'Allergies & notes', 'sub': 'None logged'},
];

class _HealthCard extends StatelessWidget {
  final String icon, name, subtitle;
  final VoidCallback onTap;
  const _HealthCard({required this.icon, required this.name,
      required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: TColors.surface,
        borderRadius: TRadius.md,
        border: Border.all(color: TColors.border),
        boxShadow: TShadow.sm,
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: TColors.tealSoft, borderRadius: TRadius.sm),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: TText.body(14, weight: FontWeight.w600, color: TColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: TText.body(11, color: TColors.textMuted)),
        ])),
        Text('›', style: TText.body(15, color: TColors.textMuted)),
      ]),
    ),
  );
}
