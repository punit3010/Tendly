import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();
  final _childNameCtrl = TextEditingController();
  DateTime? _childDob;
  String _selectedEmoji = '🐻';
  final List<String> _selectedGoals = [];
  final List<Map<String, dynamic>> _addedChildren = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _childNameCtrl.dispose();
    super.dispose();
  }

  String _ageBand(DateTime? dob) {
    if (dob == null) return 'Child';
    final months = DateTime.now().difference(dob).inDays ~/ 30;
    if (months < 12) return '${months}mo';
    final years = months ~/ 12;
    return '$years yr${years != 1 ? "s" : ""}';
  }

  void _addChild() {
    final name = _childNameCtrl.text.trim();
    if (name.isEmpty) { showTToast(context, 'Enter child\'s name'); return; }
    setState(() {
      _addedChildren.add({'name': name, 'dob': _childDob, 'emoji': _selectedEmoji});
      _childNameCtrl.clear();
      _childDob = null;
    });
  }

  void _finish() {
    final state = context.read<AppState>();
    state.parentName = _nameCtrl.text.trim();
    for (final c in _addedChildren) {
      state.addChild(Child(
        id: const Uuid().v4(),
        name: c['name'] as String,
        dob: c['dob'] as DateTime?,
        emoji: c['emoji'] as String,
      ));
    }
    state.finishOnboarding();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: TColors.forest,
      body: Stack(children: [
        const TopoBackground(),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
              child: Row(children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: i <= _step
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ))),
            ),
            Expanded(child: _buildStep()),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStep() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(_step), child: [
        _StepParentName(ctrl: _nameCtrl, onNext: () {
          if (_nameCtrl.text.trim().isEmpty) { showTToast(context, 'Please enter your name'); return; }
          setState(() => _step = 1);
        }),
        _StepAddChild(
          nameCtrl: _childNameCtrl,
          dob: _childDob,
          selectedEmoji: _selectedEmoji,
          addedChildren: _addedChildren,
          ageBand: _ageBand,
          onDobTap: () async {
            final d = await showDatePicker(context: context,
                initialDate: DateTime(DateTime.now().year - 3),
                firstDate: DateTime(DateTime.now().year - 18),
                lastDate: DateTime.now());
            if (d != null) setState(() => _childDob = d);
          },
          onEmojiSelect: (e) => setState(() => _selectedEmoji = e),
          onAdd: _addChild,
          onNext: () {
            if (_addedChildren.isEmpty) { showTToast(context, 'Add at least one child'); return; }
            setState(() => _step = 2);
          },
        ),
        _StepGoals(
          selected: _selectedGoals,
          onToggle: (g) => setState(() {
            _selectedGoals.contains(g) ? _selectedGoals.remove(g) : _selectedGoals.add(g);
          }),
          onFinish: _finish,
        ),
      ][_step]),
    );
  }
}

// ── Step 1: Parent name ──────────────────────────────────────────────────────
class _StepParentName extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onNext;
  const _StepParentName({required this.ctrl, required this.onNext});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 36, 28, 44),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Welcome to Tendly', style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
      const SizedBox(height: 14),
      RichText(text: TextSpan(style: TText.display(34, color: Colors.white), children: [
        const TextSpan(text: 'What should we call '),
        TextSpan(text: 'you?', style: TText.display(34, style: FontStyle.italic, color: TColors.mintAccent)),
      ])),
      const SizedBox(height: 10),
      Text('Your family\'s home is just a minute away.',
          style: TText.body(15, color: Colors.white.withOpacity(0.55))),
      const SizedBox(height: 40),
      _ObField(label: 'Your first name', ctrl: ctrl, placeholder: 'e.g. Priya'),
      const Spacer(),
      _ObPrimaryBtn(label: 'Continue →', onTap: onNext),
    ]),
  );
}

// ── Step 2: Add child ────────────────────────────────────────────────────────
class _StepAddChild extends StatelessWidget {
  final TextEditingController nameCtrl;
  final DateTime? dob;
  final String selectedEmoji;
  final List<Map<String, dynamic>> addedChildren;
  final String Function(DateTime?) ageBand;
  final VoidCallback onDobTap;
  final ValueChanged<String> onEmojiSelect;
  final VoidCallback onAdd;
  final VoidCallback onNext;

  const _StepAddChild({required this.nameCtrl, required this.dob,
      required this.selectedEmoji, required this.addedChildren,
      required this.ageBand, required this.onDobTap,
      required this.onEmojiSelect, required this.onAdd, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(28, 36, 28, 44),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Your Family', style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
      const SizedBox(height: 14),
      RichText(text: TextSpan(style: TText.display(34, color: Colors.white), children: [
        const TextSpan(text: 'Tell us about your '),
        TextSpan(text: 'little one.', style: TText.display(34, style: FontStyle.italic, color: TColors.mintAccent)),
      ])),
      const SizedBox(height: 10),
      Text('Tendly personalises everything to their age.',
          style: TText.body(15, color: Colors.white.withOpacity(0.55))),
      const SizedBox(height: 28),
      ...addedChildren.map((c) => _ChildAddedRow(
          emoji: c['emoji'] as String,
          name: c['name'] as String,
          ageBand: ageBand(c['dob'] as DateTime?))),
      const SizedBox(height: 16),
      _ObField(label: 'Child\'s name', ctrl: nameCtrl, placeholder: 'e.g. Arjun'),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: onDobTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: TRadius.md,
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Row(children: [
            Text(dob != null
                ? '${dob!.day}/${dob!.month}/${dob!.year}'
                : 'Date of birth',
                style: TText.body(16, color: dob != null ? Colors.white : Colors.white.withOpacity(0.3))),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      Text('PICK AN AVATAR', style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: TContent.emojis.map((e) =>
        GestureDetector(
          onTap: () => onEmojiSelect(e),
          child: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(e == selectedEmoji ? 0.18 : 0.07),
              borderRadius: TRadius.sm,
              border: Border.all(
                color: Colors.white.withOpacity(e == selectedEmoji ? 1 : 0.1),
                width: 2,
              ),
            ),
            child: Center(child: Text(e, style: const TextStyle(fontSize: 22))),
          ),
        ),
      ).toList()),
      const SizedBox(height: 20),
      _ObGhostBtn(label: '+ Add child', onTap: onAdd),
      const SizedBox(height: 14),
      _ObPrimaryBtn(label: 'Continue →', onTap: onNext),
    ]),
  );
}

// ── Step 3: Goals ────────────────────────────────────────────────────────────
class _StepGoals extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onFinish;
  const _StepGoals({required this.selected, required this.onToggle, required this.onFinish});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 36, 28, 44),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Daily Rituals', style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
      const SizedBox(height: 14),
      RichText(text: TextSpan(style: TText.display(34, color: Colors.white), children: [
        const TextSpan(text: 'What matters most '),
        TextSpan(text: 'right now?', style: TText.display(34, style: FontStyle.italic, color: TColors.mintAccent)),
      ])),
      const SizedBox(height: 10),
      Text('We\'ll build your daily rhythm around these.',
          style: TText.body(15, color: Colors.white.withOpacity(0.55))),
      const SizedBox(height: 28),
      Expanded(
        child: Wrap(spacing: 9, runSpacing: 9, children: TContent.goals.map((g) {
          final sel = selected.contains(g);
          return GestureDetector(
            onTap: () => onToggle(g),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(sel ? 0.17 : 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(sel ? 0.38 : 0.13), width: 1.5),
              ),
              child: Text(g, style: TText.body(13,
                  weight: FontWeight.w500,
                  color: Colors.white.withOpacity(sel ? 1 : 0.65))),
            ),
          );
        }).toList()),
      ),
      const SizedBox(height: 28),
      _ObPrimaryBtn(label: 'Let\'s go 🌿', onTap: onFinish),
    ]),
  );
}

// ── Helpers ──────────────────────────────────────────────────────────────────
class _ChildAddedRow extends StatelessWidget {
  final String emoji, name, ageBand;
  const _ChildAddedRow({required this.emoji, required this.name, required this.ageBand});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: TRadius.md,
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: Row(children: [
      Container(width: 38, height: 38, decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 19)))),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: TText.body(14, weight: FontWeight.w600, color: Colors.white)),
        Text(ageBand, style: TText.body(11, color: Colors.white.withOpacity(0.45))),
      ]),
    ]),
  );
}

class _ObField extends StatelessWidget {
  final String label, placeholder;
  final TextEditingController ctrl;
  const _ObField({required this.label, required this.placeholder, required this.ctrl});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label.toUpperCase(), style: TText.eyebrow(color: Colors.white.withOpacity(0.45))),
    const SizedBox(height: 9),
    TextField(
      controller: ctrl,
      style: TText.body(16, color: Colors.white),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TText.body(16, color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
            borderRadius: TRadius.md,
            borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
        enabledBorder: OutlineInputBorder(
            borderRadius: TRadius.md,
            borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
        focusedBorder: OutlineInputBorder(
            borderRadius: TRadius.md,
            borderSide: BorderSide(color: Colors.white.withOpacity(0.4))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      ),
    ),
  ]);
}

class _ObPrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ObPrimaryBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: TColors.forest,
        shape: const RoundedRectangleBorder(borderRadius: TRadius.md),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label, style: TText.body(15, weight: FontWeight.w700, color: TColors.forest)),
    ),
  );
}

class _ObGhostBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ObGhostBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white.withOpacity(0.6),
        side: BorderSide(color: Colors.white.withOpacity(0.14)),
        shape: const RoundedRectangleBorder(borderRadius: TRadius.md),
        padding: const EdgeInsets.symmetric(vertical: 13),
      ),
      child: Text(label, style: TText.body(14, weight: FontWeight.w500, color: Colors.white.withOpacity(0.6))),
    ),
  );
}
