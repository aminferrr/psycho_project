import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/emotion_entry_model.dart';
import '../../repositories/emotion_repository.dart';
import '../../services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthService>().currentUser!.uid;
    final repo = context.read<EmotionRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика эмоций')),
      body: StreamBuilder<List<EmotionEntry>>(
        stream: repo.getEmotionEntries(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snapshot.data!;

          if (entries.isEmpty) {
            return const Center(child: Text('Нет данных для статистики'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMoodChart(entries),
                const SizedBox(height: 20),
                _buildEmotionFrequency(entries),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodChart(List<EmotionEntry> entries) {
    final last7Days = entries.where((e) => e.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();
    last7Days.sort((a, b) => a.date.compareTo(b.date));

    final data = <int, double>{};
    for (var entry in last7Days) {
      final day = entry.date.day;
      data[day] = (data[day] ?? 0) + entry.moodLevel;
      final count = last7Days.where((e) => e.date.day == day).length;
      data[day] = data[day]! / count;
    }

    final spots = data.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Уровень настроения за 7 дней', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => Text(value.toInt().toString()))),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [LineChartBarData(spots: spots, isCurved: true, barWidth: 3, color: Color(
                      0xFF51266E))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionFrequency(List<EmotionEntry> entries) {
    final Map<String, int> freq = {};
    for (var e in entries) {
      for (var tag in e.tags) {
        freq[tag] = (freq[tag] ?? 0) + 1;
      }
    }

    final sorted = freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Частота эмоций', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...sorted.take(5).map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(e.key),
                  const Spacer(),
                  Text('${e.value} раз'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}