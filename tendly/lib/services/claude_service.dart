import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  static const _model = 'claude-sonnet-4-20250514';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  // API key injected via env — never hardcoded
  final String apiKey;
  ClaudeService({required this.apiKey});

  Future<Map<String, String>> generateStory({
    required String childName,
    required String ageBand,
    required String theme,
  }) async {
    const themeEmojis = {
      'Magic forest': '🌲', 'Space odyssey': '🚀', 'Ocean friends': '🐳',
      'Dragon quest': '🐉', 'Friendship': '🤝', 'Sleepy meadow': '🌙',
      'Adventure time': '⚡', 'Cozy winter': '❄️',
    };

    final prompt = '''Write a warm bedtime story for a $ageBand child named $childName with theme: $theme.
The story should be 300-400 words — enough to read aloud in 3-5 minutes.
Use vivid, gentle language with a clear beginning, middle and end.
End with the child feeling calm and sleepy.
Return ONLY valid JSON with no markdown: {"title":"...","story":"...","emoji":"one relevant emoji"}''';

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: json.encode({
          'model': _model,
          'max_tokens': 1200,
          'messages': [{'role': 'user', 'content': prompt}],
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final text = (data['content'] as List).first['text'] as String;
        final cleaned = text.replaceAll('```json', '').replaceAll('```', '').trim();
        final parsed = json.decode(cleaned) as Map<String, dynamic>;
        return {
          'title': parsed['title'] as String,
          'story': parsed['story'] as String,
          'emoji': parsed['emoji'] as String? ?? themeEmojis[theme] ?? '🌙',
        };
      }
    } catch (_) {}

    // Fallback story
    return {
      'title': '$childName and the $theme',
      'story': _fallbackStory(childName, theme),
      'emoji': themeEmojis[theme] ?? '🌙',
    };
  }

  String _fallbackStory(String name, String theme) =>
    '''Once upon a time, $name discovered something magical — a world where ${theme.toLowerCase()} adventures were real and waiting.\n\nIt began on a quiet evening, just as the sun dipped below the treetops and painted the sky in shades of rose and gold. $name followed a glowing path that wound through whispering trees, their leaves shimmering like tiny lanterns. Every step felt like a secret the forest was sharing, just for them.\n\nAlong the way, $name met a friendly creature — small and bright-eyed, with a voice like wind chimes. Together they journeyed through the heart of the ${theme.toLowerCase()} world, crossing rivers made of moonlight and climbing hills so soft they felt like pillows underfoot.\n\nAt the very top of the highest hill, $name found something wonderful: a view of the whole world, glittering quietly below. There were homes with warm lights in the windows, and somewhere among them was their own.\n\n"It\'s time," said the little creature gently. "The best adventures always end in the same beautiful place."\n\nAnd so $name made their way back, carrying the magic of the journey in their heart. They slipped under their softest blanket, eyes growing heavy with the very best kind of tiredness — the kind that only comes after a real adventure. And as they drifted into sleep, the ${theme.toLowerCase()} world was still there, waiting patiently for tomorrow night.''';
}
