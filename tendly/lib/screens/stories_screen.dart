import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/claude_service.dart';
import '../widgets/shared_widgets.dart';

class StoriesScreen extends StatefulWidget {
  final VoidCallback onBack;
  const StoriesScreen({super.key, required this.onBack});
  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  bool _loading = false;
  bool _reading = false;
  Story? _currentStory;
  bool _storySaved = false;
  final _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() => setState(() => _reading = false));
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _generate() async {
    final state = context.read<AppState>();
    final child = state.activeChild;
    setState(() { _loading = true; _currentStory = null; _storySaved = false; });

    // ClaudeService key from env — injected via Codemagic secrets
    const apiKey = String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
    final svc = ClaudeService(apiKey: apiKey);

    final result = await svc.generateStory(
      childName: child?.name ?? 'a little one',
      ageBand: child?.ageBand ?? 'young',
      theme: state.selectedTheme,
    );

    setState(() {
      _loading = false;
      _currentStory = Story(
        id: const Uuid().v4(),
        title: result['title']!,
        body: result['story']!,
        emoji: result['emoji']!,
        theme: state.selectedTheme,
        childName: child?.name ?? '',
        createdAt: DateTime.now(),
      );
    });
  }

  Future<void> _toggleReadAloud() async {
    if (_currentStory == null) return;
    if (_reading) {
      await _tts.stop();
      setState(() => _reading = false);
    } else {
      setState(() => _reading = true);
      await _tts.setLanguage('en-GB');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.05);
      await _tts.speak('${_currentStory!.title}. ${_currentStory!.body}');
    }
  }

  void _save() {
    if (_currentStory == null || _storySaved) return;
    context.read<AppState>().saveStory(_currentStory!);
    setState(() => _storySaved = true);
    showTToast(context, '"${_currentStory!.title}" saved 🔖');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [TColors.storyGradStart, Color(0xFF071A12)],
          ),
        ),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: DarkScreenHeader(
            title: 'Story Corner',
            subtitle: 'A bedtime ritual for ${state.activeChild?.name ?? "your child"}',
            bgColor: TColors.storyGradStart,
            bgColorEnd: TColors.storyGradEnd,
            onBack: widget.onBack,
          )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(delegate: SliverChildListDelegate([
              _MoodCard(
                selectedTheme: state.selectedTheme,
                onThemeSelect: state.setTheme,
                loading: _loading,
                onGenerate: _generate,
              ),
              if (_currentStory != null) ...[
                const SizedBox(height: 16),
                _StoryResultCard(
                  story: _currentStory!,
                  saved: _storySaved,
                  reading: _reading,
                  onSave: _save,
                  onReadAloud: _toggleReadAloud,
                  onNew: _generate,
                ),
              ],
              const SizedBox(height: 24),
              if (state.savedStories.isNotEmpty) ...[
                Text('Saved stories', style: TText.eyebrow(color: Colors.white.withOpacity(0.38))),
                const SizedBox(height: 12),
                ...state.savedStories.map((s) => _StoryHistoryRow(story: s)),
              ] else
                Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text('Weave your first story above',
                      style: TText.body(13, color: Colors.white.withOpacity(0.28))),
                )),
            ])),
          ),
        ]),
      );
    });
  }
}

class _MoodCard extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeSelect;
  final bool loading;
  final VoidCallback onGenerate;
  const _MoodCard({required this.selectedTheme, required this.onThemeSelect,
      required this.loading, required this.onGenerate});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.07),
      borderRadius: TRadius.lg,
      border: Border.all(color: Colors.white.withOpacity(0.11)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('What kind of story feels right tonight?',
          style: TText.body(13, color: Colors.white.withOpacity(0.6), height: 1.4)),
      const SizedBox(height: 14),
      Wrap(spacing: 8, runSpacing: 8, children: TContent.themes.map((t) {
        final sel = t == selectedTheme;
        return GestureDetector(
          onTap: () => onThemeSelect(t),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(sel ? 0.17 : 0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(sel ? 0.38 : 0.1), width: 1.5),
            ),
            child: Text('${TContent.themeEmojis[t] ?? ""} $t',
                style: TText.body(12, weight: FontWeight.w600,
                    color: Colors.white.withOpacity(sel ? 1 : 0.6))),
          ),
        );
      }).toList()),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: loading ? null : onGenerate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: TColors.forest,
            shape: const RoundedRectangleBorder(borderRadius: TRadius.md),
            padding: const EdgeInsets.symmetric(vertical: 15),
            disabledBackgroundColor: Colors.white.withOpacity(0.48),
          ),
          child: loading
              ? const SizedBox(width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: TColors.forest))
              : Text('✨ Weave a story',
                  style: TText.body(15, weight: FontWeight.w700, color: TColors.forest)),
        ),
      ),
    ]),
  );
}

class _StoryResultCard extends StatelessWidget {
  final Story story;
  final bool saved, reading;
  final VoidCallback onSave, onReadAloud, onNew;
  const _StoryResultCard({required this.story, required this.saved, required this.reading,
      required this.onSave, required this.onReadAloud, required this.onNew});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: TRadius.lg,
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(story.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(width: 14),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(story.title, style: TText.display(19, color: Colors.white)),
          )),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
        child: Text(story.body,
            style: TText.body(15, color: Colors.white.withOpacity(0.72), height: 1.7)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: Row(children: [
          Expanded(child: _StoryActionBtn(
            label: saved ? '✅ Saved' : '🔖 Save',
            saved: saved, onTap: onSave,
          )),
          const SizedBox(width: 9),
          Expanded(child: _StoryActionBtn(
            label: reading ? '⏹ Stop' : '🔊 Read aloud',
            onTap: onReadAloud,
          )),
          const SizedBox(width: 9),
          Expanded(child: _StoryActionBtn(label: '↻ New', onTap: onNew)),
        ]),
      ),
    ]),
  );
}

class _StoryActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool saved;
  const _StoryActionBtn({required this.label, required this.onTap, this.saved = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: saved ? TColors.mintAccent.withOpacity(0.15) : Colors.white.withOpacity(0.09),
        borderRadius: TRadius.md,
        border: Border.all(
            color: saved ? TColors.mintAccent.withOpacity(0.35) : Colors.white.withOpacity(0.15)),
      ),
      child: Center(child: Text(label,
          style: TText.body(12, weight: FontWeight.w700,
              color: saved ? TColors.mintAccent : Colors.white))),
    ),
  );
}

class _StoryHistoryRow extends StatelessWidget {
  final Story story;
  const _StoryHistoryRow({required this.story});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: TRadius.md,
      border: Border.all(color: Colors.white.withOpacity(0.07)),
    ),
    child: Row(children: [
      Text(story.emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 11),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(story.title, style: TText.body(13, weight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 3),
        Text('${story.theme} · ${story.childName}',
            style: TText.body(11, color: Colors.white.withOpacity(0.37))),
      ])),
      Text('›', style: TText.body(15, color: Colors.white.withOpacity(0.28))),
    ]),
  );
}
