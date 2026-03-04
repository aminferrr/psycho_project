import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../repositories/practice_repository.dart';
import '../../models/practice_journal_model.dart';
import '../../widgets/loading_indicator.dart';

class PracticeHistoryScreen extends StatelessWidget {
  const PracticeHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои практики'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<PracticeJournalEntry>>(
        stream: context.read<PracticeRepository>().getJournalEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Ошибка: ${snapshot.error}'),
                ],
              ),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.self_improvement,
                    size: 80,
                    color: Colors.deepPurple[200],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'У вас пока нет пройденных практик',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Завершите любую практику,\nи она появится здесь',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildHistoryCard(context, entry);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, PracticeJournalEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showEntryDetails(context, entry);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Иконка практики
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForPractice(entry.practiceId),
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Информация о практике
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.practiceTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(entry.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (entry.testScore != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Результат: ${entry.testScore}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Стрелка для просмотра деталей
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEntryDetails(BuildContext context, PracticeJournalEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForPractice(entry.practiceId),
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.practiceTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Пройдена: ${_formatDateFull(entry.createdAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (entry.journalText != null) ...[
                const Text(
                  'Мои заметки:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    entry.journalText!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
              if (entry.testScore != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Результат теста:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Баллы:'),
                      Text(
                        '${entry.testScore}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                  label: const Text('Закрыть'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForPractice(int practiceId) {
    switch (practiceId) {
      case 1: return Icons.visibility;
      case 2: return Icons.self_improvement;
      case 3: return Icons.gesture;
      case 4: return Icons.chair_alt;
      case 5: return Icons.filter_5;
      case 6: return Icons.mic_none;
      case 7: return Icons.air;
      case 8: return Icons.brush;
      case 9: return Icons.auto_awesome;
      case 10: return Icons.directions_walk;
      case 11: return Icons.mail_outline;
      case 12: return Icons.inventory_2_outlined;
      case 13: return Icons.shield_moon_outlined;
      case 14: return Icons.chair;
      case 15: return Icons.favorite_border;
      default: return Icons.fitness_center;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          return 'только что';
        }
        return '${diff.inMinutes} мин. назад';
      }
      return '${diff.inHours} ч. назад';
    } else if (diff.inDays == 1) {
      return 'вчера';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} д. назад';
    } else {
      return _formatDateFull(date);
    }
  }

  String _formatDateFull(DateTime date) {
    return '${date.day}.${date.month}.${date.year} в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}