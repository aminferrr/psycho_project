import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/emotion_entry_model.dart';
import '../../repositories/emotion_repository.dart';
import '../../services/auth_service.dart';

class EmotionDiaryScreen extends StatelessWidget {
  const EmotionDiaryScreen({super.key});

  // Список эмоций с картинками
  final List<Map<String, dynamic>> emotions = const [
    // === ПОЗИТИВНЫЕ ===
    {
      'name': 'Joy',
      'label': 'Радость',
      'image': 'assets/emotions/joy.png',
      'level': 5
    },
    {
      'name': 'Excitement',
      'label': 'Восторг',
      'image': 'assets/emotions/excitement.png',
      'level': 5
    },
    {
      'name': 'Satisfaction',
      'label': 'Удовлетворение',
      'image': 'assets/emotions/satisfaction.png',
      'level': 4
    },
    {
      'name': 'Love',
      'label': 'Любовь',
      'image': 'assets/emotions/love.png',
      'level': 5
    },
    {
      'name': 'Calmness',
      'label': 'Спокойствие',
      'image': 'assets/emotions/calmness.png',
      'level': 4
    },
    {
      'name': 'Gratitude',
      'label': 'Благодарность',
      'image': 'assets/emotions/gratitude.png',
      'level': 5
    },
    {
      'name': 'Fun',
      'label': 'Веселье',
      'image': 'assets/emotions/fun.png',
      'level': 5
    },
    {
      'name': 'Playfulness',
      'label': 'Игривость',
      'image': 'assets/emotions/playfulness.png',
      'level': 4
    },

    // === НЕЙТРАЛЬНЫЕ ===
    {
      'name': 'Tiredness',
      'label': 'Усталость',
      'image': 'assets/emotions/tiredness.png',
      'level': 2
    },
    {
      'name': 'Confusion',
      'label': 'Смятение',
      'image': 'assets/emotions/confusion.png',
      'level': 2
    },

    // === НЕГАТИВНЫЕ ===
    {
      'name': 'Sadness',
      'label': 'Грусть',
      'image': 'assets/emotions/sadness.png',
      'level': 1
    },
    {
      'name': 'Anxiety',
      'label': 'Тревога',
      'image': 'assets/emotions/anxiety.png',
      'level': 1
    },
    {
      'name': 'Fear',
      'label': 'Страх',
      'image': 'assets/emotions/fear.png',
      'level': 1
    },
    {
      'name': 'Anger',
      'label': 'Злость',
      'image': 'assets/emotions/anger.png',
      'level': 1
    },
    {
      'name': 'Irritation',
      'label': 'Раздражение',
      'image': 'assets/emotions/irritation.png',
      'level': 2
    },
    {
      'name': 'Disgust',
      'label': 'Отвращение',
      'image': 'assets/emotions/disgust.png',
      'level': 1
    },
    {
      'name': 'Hurt',
      'label': 'Обида',
      'image': 'assets/emotions/hurt.png',
      'level': 1
    },
    {
      'name': 'Guilt',
      'label': 'Вина',
      'image': 'assets/emotions/guilt.png',
      'level': 1
    },
    {
      'name': 'Shame',
      'label': 'Стыд',
      'image': 'assets/emotions/shame.png',
      'level': 1
    },
    {
      'name': 'Disappointment',
      'label': 'Разочарование',
      'image': 'assets/emotions/disappointment.png',
      'level': 1
    },
    {
      'name': 'Helplessness',
      'label': 'Беспомощность',
      'image': 'assets/emotions/helplessness.png',
      'level': 1
    },
    {
      'name': 'Despair',
      'label': 'Отчаяние',
      'image': 'assets/emotions/despair.png',
      'level': 1
    },
    {
      'name': 'Schadenfreude',
      'label': 'Злорадство',
      'image': 'assets/emotions/schadenfreude.png',
      'level': 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userId = context
        .read<AuthService>()
        .currentUser!
        .uid;
    final repo = context.read<EmotionRepository>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Дневник эмоций',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Отслеживайте ваше эмоциональное состояние',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),

            // Кнопка "Записать эмоцию"
            Card(
              child: ListTile(
                leading: Icon(Icons.add_reaction, color: Theme.of(context).colorScheme.primary),
                title: const Text('Записать эмоцию'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showEmotionDialog(context, userId, repo),
              ),
            ),
            const SizedBox(height: 20),

            // История
            Expanded(
              child: StreamBuilder<List<EmotionEntry>>(
                stream: repo.getEmotionEntries(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Ошибка: ${snapshot.error}');
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final entries = snapshot.data!;
                  if (entries.isEmpty) {
                    return const Center(child: Text('Нет записей'));
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final e = entries[i];
                      return _buildEmotionEntry(e, emotions);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Модальное окно ---
  void _showEmotionDialog(BuildContext context, String userId,
      EmotionRepository repo) {
    final selected = <Map<String, dynamic>>{};
    final descriptionController = TextEditingController();
    final thoughtsController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) =>
          StatefulBuilder(
            builder: (context, setState) =>
                AlertDialog(
                  title: const Text('Как вы себя чувствуете?'),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.7, // 70% высоты экрана
                    child: SingleChildScrollView( // ← ВОТ ЭТО КЛЮЧЕВОЕ!
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // === ВЫБОР ЭМОЦИЙ ===
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: emotions.map((e) {
                              final isSelected = selected.contains(e);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selected.remove(e);
                                    } else {
                                      selected.add(e);
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.blue
                                            .withOpacity(0.2) : Colors
                                            .grey[200],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Image.asset(
                                        e['image'],
                                        width: 48,
                                        height: 48,
                                        errorBuilder: (_, __, ___) =>
                                        const Icon(
                                            Icons.sentiment_neutral, size: 48),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        e['label'],
                                        style: const TextStyle(fontSize: 11),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          // === ПОЛЯ ВВОДА ===
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Что произошло?',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: thoughtsController,
                            decoration: const InputDecoration(
                              labelText: 'Мысли',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: selected.isEmpty
                          ? null
                          : () async {
                        final now = DateTime.now();
                        final avgLevel = selected.isEmpty
                            ? 3
                            : selected.map((e) => e['level'] as int).reduce((a,
                            b) => a + b) ~/ selected.length;

                        final entry = EmotionEntry(
                          id: now.millisecondsSinceEpoch.toString(),
                          userId: userId,
                          date: now,
                          moodLevel: avgLevel,
                          emoji: selected.map((e) => e['name'] as String).join(
                              ', '),
                          description: descriptionController.text,
                          thoughts: thoughtsController.text,
                          feelings: '',
                          tags: selected
                              .map((e) => e['label'] as String)
                              .toList(),
                          createdAt: now,
                          updatedAt: now,
                        );

                        await repo.addEmotionEntry(entry);
                        if (ctx.mounted) Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Эмоция сохранена!')),
                        );
                      },
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
          ),
    );
  }

  // --- Отображение записи ---
  Widget _buildEmotionEntry(EmotionEntry e,
      List<Map<String, dynamic>> emotionsList) {
    final emotionNames = e.emoji.split(', ');
    final emotionWidgets = emotionNames.map((name) {
      final emotion = emotionsList.firstWhere(
            (item) => item['name'] == name,
        orElse: () => emotionsList[0],
      );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Image.asset(
          emotion['image'],
          width: 36,
          height: 36,
          errorBuilder: (_, __, ___) =>
          const Icon(Icons.sentiment_neutral, size: 36),
        ),
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ЭМОДЖИ В РЯД ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: emotionWidgets,
            ),
            const SizedBox(height: 12),

            // --- ЭМОЦИИ (текст) ---
            Center(
              child: Text(
                e.tags.join(', '),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // --- ОПИСАНИЕ ---
            if (e.description.isNotEmpty)
              Text(
                e.description,
                style: const TextStyle(fontSize: 14),
              ),
            if (e.description.isNotEmpty) const SizedBox(height: 6),

            // --- МЫСЛИ (если есть) ---
            if (e.thoughts.isNotEmpty)
              Text(
                'Мысли: ${e.thoughts}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

            const SizedBox(height: 12),
            const Divider(),

            // --- ДАТА ---
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDate(e.date),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}