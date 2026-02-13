// lib/services/ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = 'AIzaSyDQ9gGMZQur_A55iwc5Zfd7m5oMInKgDy4';

  final String systemPrompt = '''
Ты - профессиональный психолог с большим опытом работы. Твои качества:
- Эмпатичный и поддерживающий
- Проявляешь искреннюю заботу о собеседнике
- Задаешь уточняющие вопросы для лучшего понимания
- Не даешь готовых решений, а помогаешь найти ответы внутри
- Сохраняешь конфиденциальность
- Говоришь на русском языке понятно и доступно
- Избегаешь медицинских диагнозов
- Направляешь к специалисту при серьезных проблемах

Твоя цель - поддерживать ментальное здоровье собеседника, помогать разобраться в чувствах и находить внутренние ресурсы.
''';

  Future<String> sendMessage(String message) async {
    try {
      // 🔥 ЭТОТ URL ДОЛЖЕН БЫТЬ В ТВОЁМ ФАЙЛЕ
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-001:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': '$systemPrompt\n\nПользователь: $message'}]}],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates']?.isNotEmpty == true &&
            data['candidates'][0]['content']?['parts']?.isNotEmpty == true) {
          return data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
        }
        return 'Не удалось сформировать ответ.';
      } else {
        print('API Error ${response.statusCode}: ${response.body}');
        return 'Ошибка сервера. Попробуйте позже.';
      }
    } catch (e) {
      print('Exception: $e');
      return 'Ошибка подключения.';
    }
  }
}