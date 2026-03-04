import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/psychologist_requests_screen.dart';
import '../chat/psychologist_chat_list_screen.dart';
import '../../repositories/chat_repository.dart';
import '../../services/auth_service.dart';
import '../diary/emotion_diary_screen.dart';
import '../diary/food_diary_screen.dart';
import '../forum/forum_screen.dart';
import '../practices/practices_list_screen.dart';
import '../profile/profile_screen.dart';

class PsychologistHomeScreen extends StatefulWidget {
  const PsychologistHomeScreen({Key? key}) : super(key: key);

  @override
  _PsychologistHomeScreenState createState() => _PsychologistHomeScreenState();
}

class _PsychologistHomeScreenState extends State<PsychologistHomeScreen> {
  int _selectedIndex = 0;

  // Все экраны психолога (общие + специальные чаты)
  final List<Widget> _screens = [
    const ForumScreen(),
    const PsychologistRequestsScreen(),  // Запросы от подростков
    const PsychologistChatListScreen(),  // Активные чаты
    const EmotionDiaryScreen(),          // Дневник эмоций
    const FoodDiaryScreen(),             // Дневник питания
    const PracticesListScreen(),         // Практики
    const ProfileScreen(),               // Профиль
  ];

  final List<String> _titles = [
    'Форум',
    'Запросы',
    'Чаты с подростками',
    'Дневник эмоций',
    'Дневник питания',
    'Практики',
    'Профиль',
  ];

  final List<IconData> _icons = [
    Icons.forum,
    Icons.notifications,
    Icons.chat,
    Icons.fitness_center,
    Icons.emoji_emotions,
    Icons.restaurant,
    Icons.person,
  ];

  void _showLogoutDialog(BuildContext context) {
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
              Navigator.pop(ctx);
              await authService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
        backgroundColor: Color(0xFF7E57C2),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF3E2C4A),
        unselectedItemColor: Colors.grey,
        items: List.generate(_screens.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _titles[index],
          );
        }),
      ),
    );
  }
}