import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class KitchenScreen extends StatefulWidget {
  final VoidCallback onBack;
  const KitchenScreen({super.key, required this.onBack});
  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  int _expanded = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [TColors.kitchenGradStart, Color(0xFF1A0A03)]),
      ),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: DarkScreenHeader(
          title: 'Kitchen',
          subtitle: 'Quick wins for picky eaters',
          bgColor: TColors.kitchenGradStart,
          bgColorEnd: TColors.kitchenGradEnd,
          onBack: widget.onBack,
        )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) => _RecipeCard(
              recipe: TContent.recipes[i],
              index: i,
              expanded: _expanded == i,
              onToggle: () => setState(() => _expanded = _expanded == i ? -1 : i),
              onSave: () {
                final r = TContent.recipes[i];
                context.read<AppState>().saveItem(SavedItem(
                  id: const Uuid().v4(), type: 'Recipe',
                  name: r.name, savedAt: DateTime.now()));
                showTToast(context, '"${r.name}" saved 🔖');
              },
            ),
            childCount: TContent.recipes.length,
          )),
        ),
      ]),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final bool expanded;
  final VoidCallback onToggle, onSave;
  const _RecipeCard({required this.recipe, required this.index,
      required this.expanded, required this.onToggle, required this.onSave});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
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
            Text(recipe.emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.name, style: TText.display(19, color: Colors.white)),
              const SizedBox(height: 8),
              Wrap(spacing: 7, runSpacing: 4, children: recipe.tags.map((t) =>
                Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(t, style: TText.eyebrow(color: Colors.white.withOpacity(0.55))))).toList()),
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
        secondChild: _RecipeDetail(recipe: recipe, onSave: onSave),
        crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    ]),
  );
}

class _RecipeDetail extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onSave;
  const _RecipeDetail({required this.recipe, required this.onSave});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _StatChip(recipe.time, 'Cook time'),
        const SizedBox(width: 10),
        _StatChip(recipe.serves, 'Serves'),
        const SizedBox(width: 10),
        _StatChip(recipe.age, 'Age'),
      ]),
      const SizedBox(height: 14),
      ...recipe.steps.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 22, height: 22, margin: const EdgeInsets.only(right: 10, top: 1),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text('${e.key + 1}',
                style: TText.body(11, weight: FontWeight.w700, color: Colors.white))),
          ),
          Expanded(child: Text(e.value,
              style: TText.body(13, color: Colors.white.withOpacity(0.68), height: 1.5))),
        ]),
      )),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _ActionBtn(label: '🔖 Save', onTap: onSave)),
        const SizedBox(width: 9),
        Expanded(child: _ActionBtn(label: '+ Shopping list', primary: true,
            onTap: () => showTToast(context, 'Shopping list updated'))),
      ]),
    ]),
  );
}

class _StatChip extends StatelessWidget {
  final String val, label;
  const _StatChip(this.val, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06), borderRadius: TRadius.sm),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(val, style: TText.body(15, weight: FontWeight.w700, color: Colors.white)),
      Text(label, style: TText.body(10, color: Colors.white.withOpacity(0.4))),
    ]),
  ));
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _ActionBtn({required this.label, required this.onTap, this.primary = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: primary ? Colors.white : Colors.white.withOpacity(0.08),
        borderRadius: TRadius.sm,
        border: primary ? null : Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Center(child: Text(label,
          style: TText.body(12, weight: FontWeight.w700,
              color: primary ? TColors.forest : Colors.white))),
    ),
  );
}

