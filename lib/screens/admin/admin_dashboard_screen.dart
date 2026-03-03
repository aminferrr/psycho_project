import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/loading_indicator.dart';
import 'volunteer_applications_screen.dart';
import 'users_management_screen.dart';
import 'practices_management_screen.dart';
import 'forum_moderation_screen.dart';
import 'admin_stats_screen.dart';
import 'admin_logs_screen.dart';
import '../../services/auth_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminStatsScreen(),
    const VolunteerApplicationsScreen(),
    const UsersManagementScreen(),
    const PracticesManagementScreen(),
    const ForumModerationScreen(),
    const AdminLogsScreen(),
  ];

  final List<String> _titles = [
    'Статистика',
    'Заявки волонтеров',
    'Пользователи',
    'Управление практиками',
    'Модерация форума',
    'Логи действий',
  ];

  // ✅ Метод для показа диалога выхода
  void _showLogoutDialog() {
    // Сохраняем ссылку на AuthService ДО открытия диалога
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Закрываем диалог
              Navigator.pop(ctx);
              // Используем сохраненный authService
              await authService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
          // ✅ Исправленная кнопка выхода
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,  // ← вызываем метод, а не встраиваем логику
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                ),
                SizedBox(height: 8),
                Text(
                  'Админ-панель',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(0, Icons.dashboard, 'Статистика'),
                _buildDrawerItem(1, Icons.person_add, 'Заявки волонтеров'),
                _buildDrawerItem(2, Icons.people, 'Пользователи'),
                _buildDrawerItem(3, Icons.fitness_center, 'Управление практиками'),
                _buildDrawerItem(4, Icons.forum, 'Модерация форума'),
                _buildDrawerItem(5, Icons.history, 'Логи действий'),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Настройки'),
                  onTap: () {
                    // Навигация к настройкам
                  },
                ),
                // ✅ Добавим пункт выхода и в drawer для удобства
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Выйти', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context); // закрываем drawer
                    _showLogoutDialog(); // показываем диалог выхода
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.deepPurple : null),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}