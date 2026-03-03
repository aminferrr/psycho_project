import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/loading_indicator.dart';

class AdminStatsScreen extends StatelessWidget {
  const AdminStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminRepo = Provider.of<AdminRepository>(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: adminRepo.getDashboardStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final stats = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Общая статистика',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // GridView с оптимизированными параметрами
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,  // ← уменьшил
                mainAxisSpacing: 12,    // ← уменьшил
                childAspectRatio: 1.4,  // ← оптимизировал
                children: [
                  _buildStatCard(
                    'Пользователи',
                    '${stats['totalUsers'] ?? 0}',
                    Icons.people,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Ожидают заявки',
                    '${stats['pendingVolunteers'] ?? 0}',
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Посты в форуме',
                    '${stats['totalPosts'] ?? 0}',
                    Icons.forum,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Практики',
                    '${stats['totalPractices'] ?? 0}',
                    Icons.fitness_center,
                    Colors.purple,
                  ),
                  _buildStatCard(
                    'Активны сегодня',
                    '${stats['activeToday'] ?? 0}',
                    Icons.today,
                    Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Быстрые действия',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.person_add, size: 16),
                    label: const Text('Проверить заявки', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      // Перейти к заявкам
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('Добавить практику', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      // Открыть добавление практики
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.warning, size: 16),
                    label: const Text('Модерация', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      // Перейти к модерации
                    },
                  ),
                ],
              ),
              // Обязательный отступ снизу
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // Оптимизированная карточка статистики
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),  // ← уменьшенный padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 22),  // ← уменьшенный размер
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,  // ← уменьшенный размер
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,  // ← уменьшенный размер
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}