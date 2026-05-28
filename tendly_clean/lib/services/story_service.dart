import 'dart:convert';
import 'package:http/http.dart' as http;

class StoryService {
  static const _apiKey = 'YOUR_CLAUDE_API_KEY'; // TODO: move to env
  static const _url = 'https://api.anthropic.com/v1/messages';

  // Track served stories per child to avoid repeats
  static final Map<String, List<String>> _servedTitles = {};

  static Future<Map<String, String>> generateStory({
    required String childName,
    required int childAgeYears,
    required String theme,
    String? childInterests,
  }) async {
    final servedKey = '${childName}_$childAgeYears';
    final alreadyServed = _servedTitles[servedKey] ?? [];

    final prompt = '''
Write a bedtime story for a $childAgeYears-year-old child named $childName.
Theme: $theme
${childInterests != null ? 'Interests: $childInterests' : ''}
${alreadyServed.isNotEmpty ? 'Do NOT use these titles already used: ${alreadyServed.join(', ')}' : ''}

Requirements:
- Exactly 120-150 words
- Warm, gentle, age-appropriate for $childAgeYears years old
- End with the child feeling safe and sleepy
- Use $childName as the main character
- Creative, fresh title

Respond ONLY with valid JSON, no markdown:
{"title": "...", "story": "..."}
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 400,
          'messages': [{'role': 'user', 'content': prompt}],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['content'][0]['text'] as String;
        final result = jsonDecode(text) as Map<String, dynamic>;
        final title = result['title'] as String;

        // Track to avoid repeats
        _servedTitles[servedKey] = [...alreadyServed, title];

        return {'title': title, 'story': result['story'] as String};
      }
    } catch (e) {
      // Fall through to fallback
    }

    // Fallback story if API fails
    return {
      'title': 'The Sleepy Little Star',
      'story': 'Once upon a time, $childName looked up at the sky and saw a tiny star blinking just for them. "Come to bed," the star whispered. "I will shine outside your window all night long, keeping watch." $childName smiled, closed their eyes, and drifted into the most beautiful dream — a dream full of starlight, softness, and love. Goodnight, $childName.',
    };
  }
}
