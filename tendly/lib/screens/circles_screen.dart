import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return CustomScrollView(slivers: [
        SliverToBoxAdapter(child: LightScreenHeader(
          title: 'Circles',
          subtitle: 'Your private family & community groups',
          showBack: false,
        )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            ...TContent.circles.asMap().entries.map((e) => _CircleCard(
              circle: e.value,
              expanded: state.expandedCircle == e.key,
              onToggle: () => state.setExpandedCircle(e.key),
            )),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => showTToast(context, 'Create circle — coming soon'),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: TColors.surface,
                  borderRadius: TRadius.lg,
                  border: Border.all(color: TColors.border, width: 2,
                      style: BorderStyle.solid),
                  boxShadow: TShadow.sm,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('+', style: TextStyle(fontSize: 18, color: TColors.textSecondary)),
                  const SizedBox(width: 9),
                  Text('Create a new circle',
                      style: TText.body(14, weight: FontWeight.w600, color: TColors.textSecondary)),
                ]),
              ),
            ),
          ])),
        ),
      ]);
    });
  }
}

class _CircleCard extends StatelessWidget {
  final CircleGroup circle;
  final bool expanded;
  final VoidCallback onToggle;
  const _CircleCard({required this.circle, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    decoration: BoxDecoration(
      color: TColors.surface,
      borderRadius: TRadius.lg,
      border: Border.all(color: TColors.border),
      boxShadow: TShadow.sm,
    ),
    child: Column(children: [
      GestureDetector(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            Row(children: [
              Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: TColors.tealSoft, borderRadius: TRadius.sm),
                  child: Center(child: Text(circle.emoji, style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(circle.name, style: TText.body(15, weight: FontWeight.w700, color: TColors.textPrimary)),
                const SizedBox(height: 2),
                Text(circle.meta, style: TText.body(12, color: TColors.textSecondary)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: TColors.tealSoft, borderRadius: BorderRadius.circular(5)),
                child: Text('Private', style: TText.eyebrow(color: TColors.forestMid)),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              ...circle.memberInitials.map((m) => Container(
                width: 24, height: 24,
                margin: const EdgeInsets.only(right: -5),
                decoration: BoxDecoration(
                    color: TColors.forest, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)),
                child: Center(child: Text(m,
                    style: TText.body(9, weight: FontWeight.w700, color: Colors.white))),
              )),
              const SizedBox(width: 14),
              Text('${circle.memberCount} members',
                  style: TText.body(11, color: TColors.textMuted)),
              const Spacer(),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: TColors.forestLight, size: 18),
              ),
            ]),
          ]),
        ),
      ),
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 220),
        firstChild: const SizedBox.shrink(),
        secondChild: _CirclePosts(circle: circle),
        crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    ]),
  );
}

class _CirclePosts extends StatelessWidget {
  final CircleGroup circle;
  const _CirclePosts({required this.circle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
    child: Column(children: [
      const Divider(height: 1, color: TColors.border),
      const SizedBox(height: 13),
      if (circle.playdate != null) ...[
        Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: TColors.terracottaSoft,
            borderRadius: TRadius.sm,
            border: Border.all(color: TColors.terracotta.withOpacity(0.15)),
          ),
          child: Row(children: [
            const Text('📅', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(circle.playdate!.title,
                  style: TText.body(13, weight: FontWeight.w700, color: TColors.terracotta)),
              const SizedBox(height: 2),
              Text(circle.playdate!.when, style: TText.body(11, color: TColors.textSecondary)),
            ]),
          ]),
        ),
      ],
      ...circle.posts.map((p) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: TColors.surface2, borderRadius: TRadius.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.author, style: TText.body(11, weight: FontWeight.w700, color: TColors.forest)),
          const SizedBox(height: 4),
          Text(p.text, style: TText.body(13, color: TColors.textPrimary, height: 1.5)),
          const SizedBox(height: 4),
          Text(p.time, style: TText.body(10, color: TColors.textMuted)),
        ]),
      )),
      const SizedBox(height: 4),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => showTToast(context, 'Post to circle'),
          style: OutlinedButton.styleFrom(
            foregroundColor: TColors.forest,
            side: const BorderSide(color: TColors.border),
            shape: const RoundedRectangleBorder(borderRadius: TRadius.sm),
            padding: const EdgeInsets.symmetric(vertical: 9),
          ),
          child: Text('+ Add post',
              style: TText.body(13, weight: FontWeight.w600, color: TColors.forest)),
        ),
      ),
    ]),
  );
}

