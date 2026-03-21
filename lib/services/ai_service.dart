import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/engagement_score.dart';

class AiService {
  String _endpoint = 'https://sai.sharedllm.com';
  String _model = 'gpt-oss:120b';

  void configure({required String endpoint, required String model}) {
    _endpoint = endpoint;
    _model = model;
  }

  Future<String> _chatCompletion(String systemPrompt, String userMessage) async {
    final url = Uri.parse('$_endpoint/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userMessage},
        ],
        'temperature': 0.8,
        'max_tokens': 2048,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    } else {
      throw Exception('API Error: ${response.statusCode} — ${response.body}');
    }
  }

  Stream<String> streamOptimize(String postText) async* {
    final systemPrompt = '''You are EngageBoost AI, a LinkedIn post optimization expert.
Optimize the given LinkedIn post for maximum engagement.
Return ONLY the optimized post text — no explanations, no labels, no markdown.
Apply these strategies:
- Strong hook in the first line
- Short paragraphs (1-2 sentences)
- Strategic line breaks for readability
- Emotional storytelling elements
- Clear call-to-action at the end
- Relevant hashtags (3-5)
- Use emojis sparingly but effectively''';

    try {
      final url = Uri.parse('$_endpoint/v1/chat/completions');
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': 'Optimize this LinkedIn post:\n\n$postText'},
        ],
        'temperature': 0.8,
        'max_tokens': 2048,
        'stream': true,
      });

      final client = http.Client();
      final streamedResponse = await client.send(request);
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ') && !line.contains('[DONE]')) {
          try {
            final json = jsonDecode(line.substring(6));
            final content = json['choices']?[0]?['delta']?['content'];
            if (content != null && content.isNotEmpty) {
              yield content;
            }
          } catch (_) {}
        }
      }
      client.close();
    } catch (e) {
      // Fallback to non-streaming
      final result = await _chatCompletion(
        systemPrompt,
        'Optimize this LinkedIn post:\n\n$postText',
      );
      yield result;
    }
  }

  Future<EngagementScore> scorePost(String postText) async {
    final systemPrompt = '''You are EngageBoost AI scoring engine.
Score the LinkedIn post on engagement potential.
Return ONLY valid JSON with this exact structure (no markdown, no extra text):
{
  "overall": <0-100>,
  "hook": <0-100>,
  "readability": <0-100>,
  "cta": <0-100>,
  "emotion": <0-100>,
  "formatting": <0-100>,
  "feedback": "<2-3 sentence feedback>"
}''';

    final response = await _chatCompletion(
      systemPrompt,
      'Score this LinkedIn post:\n\n$postText',
    );

    try {
      // Extract JSON from response
      final jsonStr = response.contains('{')
          ? response.substring(response.indexOf('{'), response.lastIndexOf('}') + 1)
          : response;
      final json = jsonDecode(jsonStr);
      return EngagementScore.fromJson(json);
    } catch (e) {
      return EngagementScore(
        overall: 50,
        hook: 45,
        readability: 55,
        cta: 40,
        emotion: 50,
        formatting: 60,
        feedback: 'Could not parse AI response. Please try again.',
      );
    }
  }

  Future<List<String>> generateVariants(String postText) async {
    final systemPrompt = '''You are EngageBoost AI, a LinkedIn content strategist.
Generate exactly 3 different variants of the given LinkedIn post.
Each variant should have a different tone/angle:
1. Professional & authoritative
2. Storytelling & personal
3. Data-driven & insightful

Return ONLY valid JSON array with 3 strings (no markdown, no labels):
["variant1 text", "variant2 text", "variant3 text"]''';

    final response = await _chatCompletion(
      systemPrompt,
      'Generate 3 variants of this post:\n\n$postText',
    );

    try {
      final jsonStr = response.contains('[')
          ? response.substring(response.indexOf('['), response.lastIndexOf(']') + 1)
          : response;
      final List<dynamic> variants = jsonDecode(jsonStr);
      return variants.map((v) => v.toString()).toList();
    } catch (e) {
      return [
        'Variant generation failed. Please check your connection and try again.',
        'Variant generation failed. Please check your connection and try again.',
        'Variant generation failed. Please check your connection and try again.',
      ];
    }
  }

  Future<List<String>> generateHooks(String postText) async {
    final systemPrompt = '''You are EngageBoost AI, a LinkedIn hook writing expert.
Generate exactly 5 compelling alternative opening hooks for the given LinkedIn post.
Each hook should stop the scroll and drive curiosity.
Styles: question, bold statement, statistic, story opener, contrarian take.

Return ONLY valid JSON array with 5 strings (no markdown, no labels):
["hook1", "hook2", "hook3", "hook4", "hook5"]''';

    final response = await _chatCompletion(
      systemPrompt,
      'Generate 5 hooks for this post:\n\n$postText',
    );

    try {
      final jsonStr = response.contains('[')
          ? response.substring(response.indexOf('['), response.lastIndexOf(']') + 1)
          : response;
      final List<dynamic> hooks = jsonDecode(jsonStr);
      return hooks.map((h) => h.toString()).toList();
    } catch (e) {
      return List.generate(5, (_) => 'Hook generation failed. Please try again.');
    }
  }
}
