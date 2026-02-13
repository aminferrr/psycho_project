import 'package:flutter/material.dart';
import '../models/practice_model.dart';

class PracticeCard extends StatelessWidget {
  final Practice practice;
  final VoidCallback onTap;

  const PracticeCard({
    Key? key,
    required this.practice,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          _getIconForCategory(practice.category),
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          practice.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(practice.description),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16),
                SizedBox(width: 4),
                Text('${practice.duration} мин'),
                SizedBox(width: 16),
                Icon(Icons.star, size: 16),
                SizedBox(width: 4),
                Text(practice.difficulty),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'breathing':
        return Icons.air;
      case 'grounding':
        return Icons.nature;
      case 'visualization':
        return Icons.visibility;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.psychology;
    }
  }
}