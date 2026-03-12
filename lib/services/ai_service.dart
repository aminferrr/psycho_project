// lib/services/ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AIService extends ChangeNotifier {
  // Ваш новый ключ
  final String apiKey = '';

  // Для отслеживания лимитов
  int _requestCount = 0;
  DateTime _lastReset = DateTime.now();
  bool _useLocalOnly = false;

  // Текущая модель (будет найдена автоматически)
  String _currentModel = '';
  bool _modelsLoaded = false;

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

  // Конструктор - при создании сразу ищем модель
  AIService() {
    _findAvailableModel();
  }

  // Поиск доступной модели
  Future<void> _findAvailableModel() async {
    try {
      print('🔍 Поиск доступной модели Gemini...');
      print('🌐 URL: https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey.substring(0, 8)}...');

      final response = await http.get(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey'),
      );

      print('📥 Статус ответа: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['models'] != null) {
          print('📋 Найдено моделей: ${data['models'].length}');

          // Список моделей, которые умеют генерировать текст
          List<String> availableModels = [];

          for (var model in data['models']) {
            final fullName = model['name'] ?? 'unknown';
            final name = fullName.toString().replaceFirst('models/', '');
            final methods = model['supportedGenerationMethods'] ?? [];

            // Проверяем, умеет ли модель генерировать текст
            if (methods.contains('generateContent')) {
              availableModels.add(name);
              print('  ✅ $name');
            }
          }

          // АКТУАЛЬНЫЙ ПРИОРИТЕТНЫЙ СПИСОК МОДЕЛЕЙ (2026)
          final priorityModels = [
            'gemini-2.5-flash',      // 🔥 Самая быстрая и экономичная
            'gemini-2.5-pro',        // 🧠 Самая умная
            'gemini-2.0-flash',      // ⚡ Хороший баланс
            'gemini-2.5-flash-lite', // 💰 Самая дешевая
            'gemini-1.5-flash',      // 📱 Запасной вариант
            'gemini-1.5-pro',        // 📚 Запасной вариант
          ];

          // Ищем первую доступную модель из приоритетного списка
          for (final preferred in priorityModels) {
            if (availableModels.contains(preferred)) {
              _currentModel = preferred;
              print('✨ Выбрана модель: $_currentModel');
              _modelsLoaded = true;
              _useLocalOnly = false;
              notifyListeners();
              return;
            }
          }

          // Если ни одна из приоритетных не найдена, берем первую доступную
          if (availableModels.isNotEmpty) {
            _currentModel = availableModels.first;
            print('⚠️ Выбрана альтернативная модель: $_currentModel');
            _modelsLoaded = true;
            _useLocalOnly = false;
            notifyListeners();
            return;
          }
        }
      } else {
        print('❌ Ошибка HTTP ${response.statusCode}');

        if (response.statusCode == 403) {
          print('🔐 Ошибка доступа. API ключ заблокирован или недействителен');
        }
      }

      print('❌ Не удалось найти доступные модели');
      _useLocalOnly = true;

    } catch (e) {
      print('❌ Ошибка при поиске моделей: $e');
      _useLocalOnly = true;
    }
  }

  Future<String> sendMessage(String message) async {
    // Ждем, пока модели загрузятся (максимум 3 секунды)
    if (!_modelsLoaded && !_useLocalOnly) {
      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_modelsLoaded) break;
      }
    }

    // Если модель не найдена или включен локальный режим
    if (_useLocalOnly || _currentModel.isEmpty) {
      return _getLocalResponse(message);
    }

    // Проверяем лимиты
    if (!_checkRateLimit()) {
      print('⚠️ Local mode activated due to rate limits');
      return _getLocalResponse(message);
    }

    try {
      print('📤 Отправка запроса к $message...');

      final url = 'https://generativelanguage.googleapis.com/v1beta/models/$_currentModel:generateContent?key=$apiKey';

      // ПРАВИЛЬНЫЙ ФОРМАТ ДЛЯ GEMINI 2.5
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': systemPrompt}
            ]
          },
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 1024,
          }
        }),
      );

      print('📥 Статус ответа: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            return candidate['content']['parts'][0]['text'].toString().trim();
          }
        }
        return 'Не удалось сформировать ответ.';
      }
      else if (response.statusCode == 429) {
        print('⚠️ API quota exceeded');
        return _getLocalResponse(message);
      }
      else {
        print('❌ API Error ${response.statusCode}');
        return 'Ошибка сервера. Попробуйте позже.';
      }
    } catch (e) {
      print('❌ Exception: $e');
      return 'Ошибка подключения. Проверьте интернет.';
    }
  }

  // Проверка rate limit
  bool _checkRateLimit() {
    final now = DateTime.now();

    if (now.difference(_lastReset) > const Duration(seconds: 10)) {
      _requestCount = 0;
      _lastReset = now;
    }

    if (_requestCount >= 5) {
      return false;
    }

    _requestCount++;
    return true;
  }

  // Локальные ответы на случай лимитов
  String _getLocalResponse(String message) {
    final lowerMsg = message.toLowerCase();

    if (lowerMsg.contains('привет') || lowerMsg.contains('здравствуй')) {
      return 'Здравствуйте! Рада вас слышать. Расскажите, что привело вас сегодня?';
    }
    if (lowerMsg.contains('тревог') || lowerMsg.contains('страх')) {
      return 'Тревога - это естественная реакция. Давайте попробуем подышать вместе: глубокий вдох на 4 счета, задержка на 4, медленный выдох на 6.';
    }
    if (lowerMsg.contains('груст') || lowerMsg.contains('депресс')) {
      return 'Мне жаль, что вы это чувствуете. Вы не одиноки. Помните, что это временное состояние. Хотите поговорить об этом?';
    }
    if (lowerMsg.contains('спасиб')) {
      return 'Пожалуйста! Я всегда рядом, если нужна поддержка.';
    }
    if (lowerMsg.contains('пока') || lowerMsg.contains('до свидания')) {
      return 'До свидания! Берегите себя. Возвращайтесь, когда захотите поговорить.';
    }

    return 'Я вас внимательно слушаю. Расскажите подробнее, что вас беспокоит?';
  }

  // Метод для проверки статуса
  String getCurrentModel() => _currentModel.isEmpty ? 'автономный режим' : _currentModel;

  bool get isUsingLocalMode => _useLocalOnly || _currentModel.isEmpty;

  // Принудительный поиск модели
  Future<void> refreshModels() async {
    _modelsLoaded = false;
    _useLocalOnly = false;
    await _findAvailableModel();
    notifyListeners();
  }
}