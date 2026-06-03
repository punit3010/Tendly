import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _HomeHeader(state: state, onNavigate: onNavigate)),
        SliverPadding(
          padding: const EdgeInsets.only(top: 22, bottom: 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _RoomsSection(onNavigate: onNavigate),
            const SizedBox(height: 22),
            _SavedSection(state: state),
            const SizedBox(height: 22),
            _HabitsSection(state: state),
          ])),
        ),
      ]);
    });
  }
}

// ─── HOME HEADER ─────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  final AppState state;
  final Function(int) onNavigate;
  const _HomeHeader({required this.state, required this.onNavigate});

  String get _greeting {
    final h = DateTime.now().hour;
    final name = state.parentName;
    if (h < 12) return 'Good morning, $name ☀️';
    if (h < 17) return 'Good afternoon, $name 🌤️';
    return 'Good evening, $name 🌙';
  }

  String get _todayAction {
    final h = DateTime.now().hour;
    final name = state.activeChild?.name ?? 'your little one';
    if (h < 12) return 'Start the day with <em>morning rituals</em> for $name';
    if (h < 17) return 'Perfect time for an <em>activity</em> with $name';
    return 'Time for a <em>bedtime story</em> with $name';
  }

  String get _todayTag {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Activities';
    return 'Story Corner';
  }

  String get _todayDur {
    final h = DateTime.now().hour;
    if (h < 12) return '5 min';
    if (h < 17) return '20 min';
    return '~10 min';
  }

  int get _todayNavIndex {
    final h = DateTime.now().hour;
    if (h < 17) return 3; // activities
    return 1; // stories
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: TColors.forest,
      child: Stack(children: [
        const TopoBackground(),
        Padding(
          padding: EdgeInsets.fromLTRB(THeader.sidePad, top + 12, THeader.sidePad, THeader.bottomPad),
          child: Column(children: [
            // Single row: child pills + icons
            Row(children: [
              Expanded(child: _ChildSelector(state: state)),
              const SizedBox(width: 8),
              _IconBtn(icon: '🔔', onTap: () => showTToast(context, 'Notifications coming soon')),
              const SizedBox(width: 8),
              _IconBtn(icon: '👑', onTap: () => onNavigate(5)),
            ]),
            const SizedBox(height: 10),
            // Today card
            _TodayCard(
              greeting: _greeting,
              action: _todayAction,
              tag: _todayTag,
              duration: _todayDur,
              onStart: () => onNavigate(_todayNavIndex),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(child: Text(icon, style: const TextStyle(fontSize: 15))),
    ),
  );
}

class _ChildSelector extends StatelessWidget {
  final AppState state;
  const _ChildSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        ...state.children.asMap().entries.map((e) {
          final active = e.key == state.activeChildIndex;
          return GestureDetector(
            onTap: () => state.setActiveChild(e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.fromLTRB(5, 5, 11, 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(active ? 0.17 : 0.07),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: Colors.white.withOpacity(active ? 0.38 : 0.11), width: 1.5),
              ),
              child: Row(children: [
                Container(width: 24, height: 24,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                    child: Center(child: Text(e.value.emoji, style: const TextStyle(fontSize: 13)))),
                const SizedBox(width: 6),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.value.name, style: TText.body(12, weight: FontWeight.w700, color: Colors.white)),
                  Text(e.value.ageBand, style: TText.body(10, color: Colors.white.withOpacity(0.48))),
                ]),
              ]),
            ),
          );
        }),
        GestureDetector(
          onTap: () => showTToast(context, 'Add another child — coming soon'),
          child: Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 11, 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.11), width: 1.5),
            ),
            child: Row(children: [
              Container(width: 24, height: 24,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                  child: Center(child: Text('+', style: TText.body(14, weight: FontWeight.w700, color: Colors.white)))),
              const SizedBox(width: 6),
              Text('Add', style: TText.body(12, weight: FontWeight.w700, color: Colors.white)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final String greeting, action, tag, duration;
  final VoidCallback onStart;
  const _TodayCard({required this.greeting, required this.action,
      required this.tag, required this.duration, required this.onStart});

  @override
  Widget build(BuildContext context) {
    // Parse italic parts from action string
    final parts = action.split(RegExp(r'<em>|</em>'));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: TRadius.md,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(greeting.toUpperCase(),
            style: TText.eyebrow(color: Colors.white.withOpacity(0.42))),
        const SizedBox(height: 5),
        RichText(text: TextSpan(
          style: TText.display(16, color: Colors.white),
          children: parts.asMap().entries.map((e) => TextSpan(
            text: e.value,
            style: e.key.isOdd
                ? TText.display(16, style: FontStyle.italic, color: TColors.mintAccent)
                : TText.display(16, color: Colors.white),
          )).toList(),
        )),
        const SizedBox(height: 9),
        Row(children: [
          _Tag(tag), const SizedBox(width: 8), _Tag(duration),
          const Spacer(),
          GestureDetector(
            onTap: onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Text('Start →', style: TText.body(12, weight: FontWeight.w700, color: TColors.forest)),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(5)),
    child: Text(label, style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
  );
}

// ─── ROOMS SECTION ───────────────────────────────────────────────────────────
class _RoomsSection extends StatelessWidget {
  final Function(int) onNavigate;
  const _RoomsSection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      _RoomData('📖', 'Story Corner', 'AI bedtime tales', TColors.storyGradStart, TColors.storyGradEnd, 1, false),
      _RoomData('🍳', 'Kitchen', 'Picky-eater recipes', TColors.kitchenGradStart, TColors.kitchenGradEnd, 2, false),
      _RoomData('🎨', 'Activities', 'Crafts & printables', TColors.activitiesGradStart, TColors.activitiesGradEnd, 3, true),
      _RoomData('🌱', 'Health Garden', 'Records & reminders', TColors.healthGradStart, TColors.healthGradEnd, 4, false),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Rooms'),
      const SizedBox(height: 13),
      SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: THeader.sidePad),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(width: 11),
          itemBuilder: (_, i) => _RoomCard(data: rooms[i], onTap: () => onNavigate(rooms[i].navIndex)),
        ),
      ),
    ]);
  }
}

class _RoomData {
  final String emoji, name, sub;
  final Color gradStart, gradEnd;
  final int navIndex;
  final bool isPro;
  const _RoomData(this.emoji, this.name, this.sub, this.gradStart, this.gradEnd, this.navIndex, this.isPro);
}

class _RoomCard extends StatelessWidget {
  final _RoomData data;
  final VoidCallback onTap;
  const _RoomCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 126,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [data.gradStart, data.gradEnd],
        ),
        borderRadius: TRadius.lg,
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.emoji, style: const TextStyle(fontSize: 28)),
            const Spacer(),
            Text(data.name, style: TText.body(12, weight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 3),
            Text(data.sub, style: TText.body(10, color: Colors.white.withOpacity(0.45))),
          ]),
        ),
        if (data.isPro)
          Positioned(top: 11, right: 11, child: const ProBadge()),
      ]),
    ),
  );
}

// ─── SAVED SECTION ───────────────────────────────────────────────────────────
class _SavedSection extends StatelessWidget {
  final AppState state;
  const _SavedSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Saved', action: 'See all', onAction: () {}),
      const SizedBox(height: 13),
      if (state.savedItems.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: THeader.sidePad),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: TColors.surface,
              borderRadius: TRadius.md,
              border: Border.all(color: TColors.border, style: BorderStyle.solid, width: 1.5),
            ),
            child: Column(children: [
              const Text('🔖', style: TextStyle(fontSize: 26)),
              const SizedBox(height: 9),
              Text('Save stories, recipes & activities here. They\'ll wait for you.',
                  textAlign: TextAlign.center,
                  style: TText.body(13, color: TColors.textMuted, height: 1.5)),
            ]),
          ),
        )
      else
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: THeader.sidePad),
            itemCount: state.savedItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 11),
            itemBuilder: (_, i) {
              final item = state.savedItems[i];
              return Container(
                width: 155,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: TColors.surface,
                  borderRadius: TRadius.md,
                  border: Border.all(color: TColors.border),
                  boxShadow: TShadow.sm,
                ),
                child: Stack(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.type.toUpperCase(), style: TText.eyebrow()),
                    const SizedBox(height: 5),
                    Text(item.name, style: TText.body(13, weight: FontWeight.w600,
                        color: TColors.textPrimary, height: 1.3),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text('Open →', style: TText.body(12, weight: FontWeight.w600, color: TColors.forestLight)),
                  ]),
                  Positioned(top: 0, right: 0,
                    child: GestureDetector(
                      onTap: () => state.removeItem(item.id),
                      child: Text('×', style: TText.body(16, color: TColors.textMuted)),
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
    ]);
  }
}

// ─── HABITS SECTION ──────────────────────────────────────────────────────────
class _HabitsSection extends StatelessWidget {
  final AppState state;
  const _HabitsSection({required this.state});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(title: 'Today\'s rituals', action: 'Edit', onAction: () {}),
      const SizedBox(height: 13),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: THeader.sidePad),
        child: Column(
          children: state.habits.asMap().entries.map((e) {
            final h = e.value;
            return GestureDetector(
              onTap: () => state.toggleHabit(e.key),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: h.done ? 0.52 : 1,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(
                    color: TColors.surface,
                    borderRadius: TRadius.md,
                    border: Border.all(color: TColors.border),
                    boxShadow: TShadow.sm,
                  ),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 21, height: 21,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: h.done ? TColors.forest : Colors.transparent,
                        border: Border.all(
                            color: h.done ? TColors.forest : TColors.border, width: 2),
                      ),
                      child: h.done
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 13),
                    Expanded(child: Text(h.name,
                        style: TText.body(14, weight: FontWeight.w500,
                            color: h.done ? TColors.textMuted : TColors.textPrimary),
                        overflow: TextOverflow.ellipsis)),
                    if (h.streak > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            color: TColors.terracottaSoft, borderRadius: BorderRadius.circular(18)),
                        child: Text('🔥 ${h.streak}',
                            style: TText.body(11, weight: FontWeight.w700, color: TColors.terracotta)),
                      ),
                  ]),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}
