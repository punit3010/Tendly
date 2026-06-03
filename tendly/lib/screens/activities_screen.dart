import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class ActivitiesScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onUpgrade;
  const ActivitiesScreen({super.key, required this.onBack, required this.onUpgrade});
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String _filter = 'All';
  int _expanded = -1;

  List<Activity> get _filtered => TContent.activities
      .where((a) => _filter == 'All' || a.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [TColors.activitiesGradStart, Color(0xFF050D1A)]),
      ),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: DarkScreenHeader(
          title: 'Activity Center',
          subtitle: 'Crafts, printables & scavenger hunts',
          bgColor: TColors.activitiesGradStart,
          bgColorEnd: TColors.activitiesGradEnd,
          onBack: widget.onBack,
        )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: TContent.activityCategories.map((cat) {
                final sel = cat == _filter;
                return GestureDetector(
                  onTap: () => setState(() { _filter = cat; _expanded = -1; }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(sel ? 0.17 : 0.07),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(sel ? 0.38 : 0.1), width: 1.5),
                    ),
                    child: Text(cat, style: TText.body(12, weight: FontWeight.w600,
                        color: Colors.white.withOpacity(sel ? 1 : 0.6))),
                  ),
                );
              }).toList()),
            ),
            const SizedBox(height: 20),
            ..._filtered.asMap().entries.map((e) {
              final realIndex = TContent.activities.indexOf(e.value);
              return _ActivityCard(
                activity: e.value,
                expanded: _expanded == realIndex,
                onToggle: () => setState(() => _expanded = _expanded == realIndex ? -1 : realIndex),
                onSave: () {
                  context.read<AppState>().saveItem(SavedItem(
                    id: const Uuid().v4(), type: 'Activity',
                    name: e.value.name, savedAt: DateTime.now()));
                  showTToast(context, '"${e.value.name}" saved 🔖');
                },
                onPrint: widget.onUpgrade,
              );
            }),
          ])),
        ),
      ]),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool expanded;
  final VoidCallback onToggle, onSave, onPrint;
  const _ActivityCard({required this.activity, required this.expanded,
      required this.onToggle, required this.onSave, required this.onPrint});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.07),
      borderRadius: TRadius.lg,
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: Column(children: [
      GestureDetector(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(activity.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(activity.name, style: TText.display(17, color: Colors.white)),
              const SizedBox(height: 7),
              Wrap(spacing: 8, runSpacing: 4, children: activity.tags.map((t) =>
                Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(t, style: TText.eyebrow(color: Colors.white.withOpacity(0.5))))).toList()),
            ])),
            AnimatedRotation(
              turns: expanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.4)),
            ),
          ]),
        ),
      ),
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 220),
        firstChild: const SizedBox.shrink(),
        secondChild: _ActivityDetail(activity: activity, onSave: onSave, onPrint: onPrint),
        crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    ]),
  );
}

class _ActivityDetail extends StatelessWidget {
  final Activity activity;
  final VoidCallback onSave, onPrint;
  const _ActivityDetail({required this.activity, required this.onSave, required this.onPrint});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(activity.description,
          style: TText.body(14, color: Colors.white.withOpacity(0.65), height: 1.6)),
      const SizedBox(height: 14),
      Text('HOW TO DO IT', style: TText.eyebrow(color: Colors.white.withOpacity(0.38))),
      const SizedBox(height: 10),
      ...activity.steps.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 20, height: 20, margin: const EdgeInsets.only(right: 10, top: 2),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Text('${e.key + 1}',
                style: TText.body(10, weight: FontWeight.w700, color: Colors.white))),
          ),
          Expanded(child: Text(e.value,
              style: TText.body(13, color: Colors.white.withOpacity(0.62), height: 1.5))),
        ]),
      )),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: GestureDetector(
          onTap: onSave,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: TRadius.sm,
                border: Border.all(color: Colors.white.withOpacity(0.12))),
            child: Center(child: Text('🔖 Save',
                style: TText.body(12, weight: FontWeight.w700, color: Colors.white))),
          ),
        )),
        const SizedBox(width: 9),
        Expanded(child: _PrintBtn(isPrintable: activity.isPrintable, onPrint: onPrint)),
      ]),
    ]),
  );
}

class _PrintBtn extends StatelessWidget {
  final bool isPrintable;
  final VoidCallback onPrint;
  const _PrintBtn({required this.isPrintable, required this.onPrint});

  @override
  Widget build(BuildContext context) => Stack(children: [
    Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: TRadius.sm),
      child: Center(child: Text(isPrintable ? '🖨️ Print sheet' : '✅ Start now',
          style: TText.body(12, weight: FontWeight.w700, color: TColors.forest))),
    ),
    if (isPrintable)
      Positioned.fill(child: GestureDetector(
        onTap: onPrint,
        child: Container(
          decoration: BoxDecoration(
              color: TColors.forest.withOpacity(0.65),
              borderRadius: TRadius.sm),
          child: Center(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(color: Colors.white, borderRadius: TRadius.sm),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('👑', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text('Pro', style: TText.body(12, weight: FontWeight.w700, color: TColors.forest)),
            ]),
          )),
        ),
      )),
  ]);
}

