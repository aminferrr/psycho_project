import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/food_entry_model.dart';
import '../../repositories/food_repository.dart';
import '../../services/auth_service.dart';
import 'food_entry_details_screen.dart';

class FoodDiaryScreen extends StatelessWidget {
  const FoodDiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthService>().currentUser!.uid;
    final repo = context.read<FoodRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник питания 🍽'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  'Добавить приём пищи',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E2C4A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showAddFoodDialog(context, userId, repo),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<FoodEntry>>(
              stream: repo.getFoodEntries(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Ошибка: ${snapshot.error}');
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final entries = snapshot.data!;
                if (entries.isEmpty) {
                  return const Center(child: Text('Пока нет записей'));
                }

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading:
                        const Icon(Icons.restaurant, color: Color(0xFF4F309E)),
                        title: Text(e.foodItems.map((f) => f.name).join(', ')),
                        subtitle: Text(
                          '${_formatTime(e.timestamp)} • ${e.context}',
                        ),
                        trailing: Text(
                          _behaviorEmoji(e.behavior),
                          style: const TextStyle(fontSize: 22),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodEntryDetailsScreen(entry: e),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ Диалог добавления ------------------
  void _showAddFoodDialog(
      BuildContext context, String userId, FoodRepository repo) {
    final foodController = TextEditingController();
    final thoughtsController = TextEditingController();
    final selfNoteController = TextEditingController();
    final triggerController = TextEditingController();
    final supportController = TextEditingController();
    final insightController = TextEditingController();

    String place = 'Дом';
    String company = 'Одна';
    String behavior = 'Обычный приём пищи';
    String emotionBefore = 'Спокойствие';
    String emotionAfter = 'Удовлетворение';
    String compensation = 'Нет';
    int hunger = 3;
    int satiety = 3;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Добавить приём пищи 🍽'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Разделы (оставлены без изменений) ---
                _infoRow('🕒 Время', 'Вводишь время, когда ела', '09:30'),
                _infoRow('🍲 Что ела', 'Просто словами', 'Овсянка с яблоком'),
                TextField(
                  controller: foodController,
                  decoration: const InputDecoration(
                    labelText: 'Что ела',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: place,
                  decoration: const InputDecoration(labelText: '📍 Место'),
                  items: ['Дом', 'Кафе', 'Работа', 'На улице']
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => place = v!),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: company,
                  decoration: const InputDecoration(labelText: '👥 С кем'),
                  items: ['Одна', 'С друзьями', 'С семьёй']
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => company = v!),
                ),

                const Divider(height: 24),

                const Text('💬 Раздел 2. Эмоции и мысли',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: emotionBefore,
                  decoration:
                  const InputDecoration(labelText: '😊 Эмоции до еды'),
                  items: [
                    'Спокойствие',
                    'Тревога',
                    'Радость',
                    'Скука',
                    'Грусть',
                    'Злость'
                  ]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => emotionBefore = v!),
                ),
                DropdownButtonFormField<String>(
                  value: emotionAfter,
                  decoration:
                  const InputDecoration(labelText: '😋 Эмоции после еды'),
                  items: [
                    'Спокойствие',
                    'Удовлетворение',
                    'Вина',
                    'Тяжесть',
                    'Радость'
                  ]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => emotionAfter = v!),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: thoughtsController,
                  decoration: const InputDecoration(
                      labelText: '💭 Мысли', border: OutlineInputBorder()),
                ),

                const Divider(height: 24),

                // --- Поведение ---
                const Text('⚖️ Раздел 3. Поведение',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: behavior,
                  decoration:
                  const InputDecoration(labelText: '🧍‍♀️ Тип поведения'),
                  items: [
                    'Обычный приём пищи',
                    'Переедание',
                    'Ограничение',
                    'Пропуск',
                    'Срыв'
                  ]
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => behavior = v!),
                ),
                DropdownButtonFormField<String>(
                  value: compensation,
                  decoration: const InputDecoration(
                      labelText: '🔁 Компенсаторные действия'),
                  items: ['Нет', 'Спорт', 'Голодание', 'Подсчёт калорий']
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => compensation = v!),
                ),
                TextField(
                  controller: triggerController,
                  decoration: const InputDecoration(
                      labelText: '🚫 Триггеры (например: стресс, скука)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),

                const Text('🔢 Уровень голода'),
                _emojiScale(setState, hunger, (v) => hunger = v,
                    ['😴', '😐', '🙂', '😋', '🤤']),
                const SizedBox(height: 16),
                const Text('🧘 Уровень сытости'),
                _emojiScale(setState, satiety, (v) => satiety = v,
                    ['😫', '😐', '🙂', '😌', '😴']),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();

                final entry = FoodEntry(
                  id: now.millisecondsSinceEpoch.toString(),
                  userId: userId,
                  timestamp: now,
                  context: '$place, $company',
                  foodItems: [
                    FoodItem(name: foodController.text, quantity: '', notes: '')
                  ],
                  hungerBefore: hunger,
                  hungerAfter: satiety,
                  emotionsBefore: [emotionBefore],
                  emotionsAfter: [emotionAfter],
                  thoughts: thoughtsController.text,
                  behavior: behavior,
                  compensation: compensation,
                  triggers: triggerController.text,
                  support: supportController.text,
                  selfNote: selfNoteController.text,
                  insight: insightController.text,
                  createdAt: now,
                  updatedAt: now,
                );

                await repo.addFoodEntry(entry);
                if (ctx.mounted) Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Запись о приёме пищи сохранена ✅')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  // --------- Вспомогательные функции ---------
  static Widget _infoRow(String emoji, String hint, String example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 8),
          Expanded(
              child: Text('$hint (пример: $example)',
                  style: const TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  static Widget _emojiScale(void Function(void Function()) setState, int value,
      void Function(int) onTap, List<String> faces) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final selected = value == i + 1;
        return GestureDetector(
          onTap: () => setState(() => onTap(i + 1)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
              selected ? Colors.green.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(faces[i], style: const TextStyle(fontSize: 26)),
                Text('${i + 1}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _behaviorEmoji(String behavior) {
    switch (behavior) {
      case 'Переедание':
        return '🍽️';
      case 'Ограничение':
        return '🥦';
      case 'Пропуск':
        return '🚫';
      case 'Срыв':
        return '💥';
      default:
        return '✅';
    }
  }
}
