import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String _selectedTheme = 'Adventure';
  bool _isGenerating = false;
  bool _hasStory = true;

  final List<String> _themes = [
    'Adventure', 'Animals', 'Magic', 'Space', 'Ocean', 'Friendship'
  ];

  final Map<String, Map<String, String>> _stories = {
    'Adventure': {
      'title': 'The Dragon Who Lost Her Wings',
      'body': 'Once upon a time, in a valley where clouds touched the treetops, there lived a little dragon named Aria. Unlike the other dragons, her wings were made of morning dew and starlight — magical, but oh so delicate.\n\nOne breezy Tuesday, a gust of wind carried her wings away into the sky. Aria stood very still and took a deep breath.\n\n"I may not have my wings," she said bravely, "but I have my heart."\n\nAnd with that, she began the most extraordinary adventure of her life — on foot, with friends she had never met, heading toward a horizon she had never seen.',
    },
    'Animals': {
      'title': 'Aria and the Whispering Woods',
      'body': 'Deep in the Whispering Woods, a little girl named Aria discovered she could speak to every animal — from the tallest giraffe to the tiniest firefly.\n\nOne morning, the oldest oak tree called out: "Little one, the forest needs your gift today."\n\nAria perked up her ears and ran toward the sound. A family of rabbits had lost their way home. She listened, and guided them gently through the silver ferns, back to their burrow just as the stars began to appear.',
    },
    'Magic': {
      'title': 'The Glowing Acorn',
      'body': 'Aria found a glowing acorn in her garden one Tuesday morning. When she held it close, it whispered softly: "Plant me where you love most."\n\nShe dug a small hole beneath her bedroom window, tucked the acorn in gently, and sang it a little song.\n\nBy bedtime, a silver tree had grown — its leaves chiming soft lullabies just for her, and its branches catching moonbeams like fireflies in a jar.',
    },
    'Space': {
      'title': 'Captain Aria and the Lost Constellation',
      'body': 'Captain Aria of the Starship Poppyseed had one mission: find the lost constellation of the Friendly Bear. Her co-pilot, a round robot named Boop, beeped excitedly as they zoomed past Jupiter.\n\n"Stars at twelve o\'clock!" Boop chirped.\n\nAria smiled and steered toward the light. There it was — seven stars arranged in the shape of a bear giving a hug. She marked it on her map and named it after her favourite person.',
    },
    'Ocean': {
      'title': 'The Mermaid Who Collected Songs',
      'body': 'Below the waves, where sunlight turned everything golden, lived a young mermaid named Aria who collected lost songs from shipwrecks.\n\nOne evening, she found a music box playing a tune nobody recognised — except the oldest whale, who smiled and said:\n\n"That\'s the song the ocean sang on the very first day." Aria held it close and listened until the last note faded into the deep, blue quiet.',
    },
    'Friendship': {
      'title': 'The Girl Who Kept Promises',
      'body': 'Aria had a best friend named River who lived across the meadow. One autumn, River moved far away and cried for days. Before she left, Aria handed her a small jar.\n\n"What\'s in it?" River asked.\n\n"A promise," said Aria. "Open it whenever you miss me."\n\nInside was a folded note that said: "I\'m never more than a dream away." River kept that jar on her windowsill for the rest of her life.',
    },
  };

  Future<void> _generateStory() async {
    setState(() { _isGenerating = true; _hasStory = false; });
    // TODO: Replace with real Claude API call
    // final response = await http.post(
    //   Uri.parse('https://api.anthropic.com/v1/messages'),
    //   headers: {'x-api-key': apiKey, 'content-type': 'application/json'},
    //   body: jsonEncode({
    //     'model': 'claude-sonnet-4-20250514',
    //     'max_tokens': 500,
    //     'messages': [{'role': 'user', 'content':
    //       'Write a short bedtime story for a 4 year old named Aria. Theme: $_selectedTheme. Max 150 words. Warm, gentle, age-appropriate.'}]
    //   }),
    // );
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _isGenerating = false; _hasStory = true; });
  }

  @override
  Widget build(BuildContext context) {
    final story = _stories[_selectedTheme]!;

    return Scaffold(
      backgroundColor: TendlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: TendlyColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    Icon(Icons.bedtime_outlined,
                      color: Colors.white, size: 36),
                    const SizedBox(height: 8),
                    const Text('Bedtime story',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                    const SizedBox(height: 4),
                    const Text('Personalized for Aria, age 4',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: TendlyColors.primaryLight,
                      )),
                  ],
                ),
              ),

              // ── Body ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pick a theme',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TendlyColors.primaryDeep,
                      )),
                    const SizedBox(height: 10),

                    // Theme chips
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _themes.map((t) {
                        final sel = t == _selectedTheme;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTheme = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                ? TendlyColors.primary
                                : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                  ? TendlyColors.primary
                                  : TendlyColors.border,
                              ),
                            ),
                            child: Text(t,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: sel
                                  ? Colors.white
                                  : TendlyColors.primaryDark,
                              )),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Generate button
                    ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateStory,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: Text(
                        _isGenerating
                          ? 'Generating...'
                          : 'Generate tonight\'s story'),
                    ),

                    const SizedBox(height: 20),

                    // Story output
                    if (_isGenerating)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TendlyColors.border),
                        ),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              color: TendlyColors.primary,
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 16),
                            Text('Writing a story for Aria...',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: TendlyColors.textSecondary,
                              )),
                          ],
                        ),
                      ),

                    if (_hasStory && !_isGenerating) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TendlyColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: TendlyColors.primaryMist,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Tonight\'s story',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: TendlyColors.primaryDark,
                                    )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(story['title']!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: TendlyColors.primaryDeep,
                                height: 1.3,
                              )),
                            const SizedBox(height: 12),
                            Text(story['body']!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: TendlyColors.primaryDark,
                                height: 1.8,
                              )),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.refresh,
                                    size: 16, color: TendlyColors.primary),
                                  label: const Text('New story',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: TendlyColors.primary,
                                    )),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.bookmark_border,
                                    size: 16, color: TendlyColors.primary),
                                  label: const Text('Save',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: TendlyColors.primary,
                                    )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: TendlyColors.primary,
        unselectedItemColor: TendlyColors.primaryLight,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 10),
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), activeIcon: Icon(Icons.auto_stories), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
