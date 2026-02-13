import 'package:flutter/material.dart';
import 'breathing_practice_screen.dart';
import 'grounding_54321_screen.dart';


class PracticesListScreen extends StatelessWidget {
  const PracticesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Практики'),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPracticeCard(
            'Медитация осознанности',
            '10 минут',
            Icons.self_improvement,
            Colors.green,
          ),
          _buildPracticeCard(
            'Дыхательные упражнения',
            '5 минут',
            Icons.air,
            Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BreathingPracticeScreen(),
                ),
              );
            },
          ),
          _buildPracticeCard(
            'Техника благодарности',
            '7 минут',
            Icons.favorite,
            Colors.red,
          ),
          _buildPracticeCard(
            'Техника 5-4-3-2-1',
            '10 минут',
            Icons.touch_app,
            Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Grounding54321Screen(),
                ),
              );
            },
          ),
          _buildPracticeCard(
            'Прогрессивная релаксация',
            '15 минут',
            Icons.nightlight_round,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  // ✅ Добавили параметр onTap
  Widget _buildPracticeCard(
      String title,
      String duration,
      IconData icon,
      Color color, {
        VoidCallback? onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(duration),
        trailing: Icon(Icons.play_arrow, color: color),
        onTap: onTap, // теперь передаётся правильно
      ),
    );
  }
}
