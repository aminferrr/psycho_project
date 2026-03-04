import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';
import '../utils/anon_generator.dart'; // Добавьте импорт

class ForumPostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback? onTap;

  const ForumPostCard({
    Key? key,
    required this.post,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    // ✅ ИСПРАВЛЕНО: используем AnonGenerator
                    backgroundImage: post.avatarUrl.isNotEmpty
                        ? AnonGenerator.getAvatarImage(post.avatarUrl)
                        : null,
                    child: post.avatarUrl.isEmpty
                        ? Text(post.nickname[0].toUpperCase())
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatDate(post.timestamp),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(post.content),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.comment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${post.commentCount}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} д. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }
}