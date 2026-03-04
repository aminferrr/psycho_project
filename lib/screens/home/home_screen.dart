import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../diary/emotion_diary_screen.dart';
import '../diary/food_diary_screen.dart';
import '../chat/chat_list_screen.dart';
import '../practices/practices_list_screen.dart';
import '../profile/profile_screen.dart';
import '../forum/forum_screen.dart';
import '../diary/statistics_screen.dart'; // добавь если нет

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Форум теперь — главный экран
  final List<Widget> _screens = [
    const ForumScreen(),       // Главная вкладка
    const DiaryMainScreen(),   // Дневник
    const ChatListScreen(),    // Чаты (ИИ + волонтёры)
    const PracticesListScreen(), // Практики
    const ProfileScreen(),     // Профиль
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Форум',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Дневник',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Практики',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

// Экран дневника с табами и иконкой статистики
class DiaryMainScreen extends StatelessWidget {
  const DiaryMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Дневник'),
          actions: [
            IconButton(
              icon: const Icon(Icons.analytics_outlined),
              tooltip: 'Статистика',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.emoji_emotions), text: 'Эмоции'),
              Tab(icon: Icon(Icons.restaurant), text: 'Питание'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EmotionDiaryScreen(),
            FoodDiaryScreen(),
          ],
        ),
      ),
    );
  }
}
