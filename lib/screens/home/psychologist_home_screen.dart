import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/psychologist_requests_screen.dart';
import '../chat/psychologist_chat_list_screen.dart';
import '../../repositories/chat_repository.dart';
import '../../services/auth_service.dart';

class PsychologistHomeScreen extends StatefulWidget {
  const PsychologistHomeScreen({Key? key}) : super(key: key);

  @override
  _PsychologistHomeScreenState createState() => _PsychologistHomeScreenState();
}

class _PsychologistHomeScreenState extends State<PsychologistHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PsychologistRequestsScreen(),
    const PsychologistChatListScreen(),
    const Center(child: Text('Статистика')),
    const Center(child: Text('Профиль')),
  ];

  final List<String> _titles = [
    'Запросы',
    'Чаты',
    'Статистика',
    'Профиль',
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Запросы'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чаты'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}