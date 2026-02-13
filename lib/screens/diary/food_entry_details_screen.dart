import 'package:flutter/material.dart';
import '../../models/food_entry_model.dart';

class FoodEntryDetailsScreen extends StatelessWidget {
  final FoodEntry entry;

  const FoodEntryDetailsScreen({Key? key, required this.entry})
      : super(key: key);

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Запись о приёме пищи"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "🕒 Время",
              Text("${_formatDate(entry.timestamp)} — ${_formatTime(entry.timestamp)}"),
            ),

            _buildSection(
              "🍲 Что ела",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.foodItems.map((item) {
                  return Text("• ${item.name} — ${item.quantity}");
                }).toList(),
              ),
            ),

            _buildSection(
              "📍 Контекст",
              Text(entry.context),
            ),

            _buildSection(
              "😋 Голод до / после",
              Text(
                  "До еды: ${entry.hungerBefore}\nПосле еды: ${entry.hungerAfter}"),
            ),

            if (entry.emotionsBefore.isNotEmpty)
              _buildSection(
                "😊 Эмоции до",
                Wrap(
                  children: entry.emotionsBefore.map((e) =>
                      Chip(label: Text(e))).toList(),
                ),
              ),

            if (entry.emotionsAfter.isNotEmpty)
              _buildSection(
                "😌 Эмоции после",
                Wrap(
                  children: entry.emotionsAfter.map((e) =>
                      Chip(label: Text(e))).toList(),
                ),
              ),

            if (entry.thoughts.isNotEmpty)
              _buildSection("💭 Мысли", Text(entry.thoughts)),

            _buildSection("🧍‍♀️ Поведение", Text(entry.behavior)),

            if (entry.compensation != null && entry.compensation!.isNotEmpty)
              _buildSection("🔁 Компенсации", Text(entry.compensation!)),

            if (entry.triggers != null && entry.triggers!.isNotEmpty)
              _buildSection("🚫 Триггеры", Text(entry.triggers!)),

            if (entry.support != null && entry.support!.isNotEmpty)
              _buildSection("🌼 Что помогло", Text(entry.support!)),

            if (entry.selfNote != null && entry.selfNote!.isNotEmpty)
              _buildSection("❤️ Поддержка себе", Text(entry.selfNote!)),

            if (entry.insight != null && entry.insight!.isNotEmpty)
              _buildSection("📈 Осознания", Text(entry.insight!)),
          ],
        ),
      ),
    );
  }
}
