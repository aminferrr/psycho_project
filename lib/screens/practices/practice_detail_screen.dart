import 'package:flutter/material.dart';
import '../../models/practice_model.dart';

class PracticeDetailScreen extends StatelessWidget {
  final Practice practice;

  const PracticeDetailScreen({Key? key, required this.practice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(practice.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              practice.description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            _buildInfoRow('Длительность', '${practice.duration} минут'),
            _buildInfoRow('Сложность', practice.difficulty),
            _buildInfoRow('Категория', practice.category),
            SizedBox(height: 24),
            Text(
              'Шаги:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...practice.steps.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final step = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _startPractice(context);
        },
        icon: Icon(Icons.play_arrow),
        label: Text('Начать практику'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _startPractice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Начать практику'),
        content: Text('Вы готовы начать практику "${practice.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement practice timer and guidance
              _showPracticeInProgress(context);
            },
            child: Text('Начать'),
          ),
        ],
      ),
    );
  }

  void _showPracticeInProgress(BuildContext context) {
    // TODO: Implement practice session with timer and step-by-step guidance
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Практика "${practice.title}" началась'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}