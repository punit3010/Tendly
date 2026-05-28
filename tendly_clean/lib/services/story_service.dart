import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/keys.dart';

class StoryService {
  static const _url = 'https://api.anthropic.com/v1/messages';
  static final Map<String, List<String>> _servedTitles = {};

  static Future<Map<String, String>> generateStory({
    required String childName,
    required int childAgeYears,
    required String theme,
  }) async {
    final servedKey = '${childName}_$childAgeYears';
    final alreadyServed = _servedTitles[servedKey] ?? [];

    final prompt = '''
Write a bedtime story for a $childAgeYears-year-old child named $childName.
Theme: $theme
${alreadyServed.isNotEmpty ? 'Do NOT reuse these titles: ${alreadyServed.join(', ')}' : ''}
Requirements: 120-150 words, warm, gentle, age-appropriate, $childName as hero, ends sleepily.
Respond ONLY with valid JSON: {"title": "...", "story": "..."}
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'x-api-key': AppKeys.claudeApiKey,
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
        final data   = jsonDecode(response.body);
        final text   = data['content'][0]['text'] as String;
        final result = jsonDecode(text) as Map<String, dynamic>;
        final title  = result['title'] as String;
        _servedTitles[servedKey] = [...alreadyServed, title];
        return {'title': title, 'story': result['story'] as String};
      }
    } catch (_) {}

    return {
      'title': 'The Sleepy Little Star',
      'story': 'Once upon a time, $childName looked up and saw a tiny star blinking just for them. "Come to bed," the star whispered softly. "I will shine outside your window all night, keeping watch." $childName smiled, closed their eyes, and drifted into the most beautiful dream — full of starlight, softness, and love. Goodnight, $childName.',
    };
  }
}
