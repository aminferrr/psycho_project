import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/forum_post_model.dart';
import '../../models/forum_comment_model.dart';
import '../../repositories/forum_repository.dart';
import '../../services/auth_service.dart';
import '../../utils/anon_generator.dart'; // Для генерации анонимных ников

class PostDetailScreen extends StatefulWidget {
  final ForumPost post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _controller = TextEditingController();

  // Вспомогательная функция для получения первой буквы
  String _getInitial(String? text) {
    if (text == null || text.isEmpty) return '?';
    return text[0].toUpperCase();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthService>().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите, чтобы оставить комментарий')),
      );
      return;
    }

    // Генерируем случайный анонимный профиль (животное + аватар)
    final anonProfile = AnonGenerator.randomProfile();

    final comment = ForumComment(
      id: '',
      postId: widget.post.id,
      userId: user.uid,
      nickname: anonProfile['name'] ?? 'Анонимное животное',
      avatarUrl: anonProfile['avatar'] ?? '',
      content: text,
      timestamp: DateTime.now(),
    );

    context.read<ForumRepository>().addForumComment(comment);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ForumRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Форум'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Карточка поста
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: widget.post.avatarUrl.isNotEmpty
                            ? AnonGenerator.getAvatarImage(widget.post.avatarUrl)
                            : null,
                        // ✅ Исправлено: используем _getInitial
                        child: widget.post.avatarUrl.isEmpty
                            ? Text(_getInitial(widget.post.nickname))
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.nickname,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _formatTime(widget.post.timestamp),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.post.content, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const Divider(),
          // Комментарии
          Expanded(
            child: StreamBuilder<List<ForumComment>>(
              stream: repo.getForumComments(widget.post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }

                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(child: Text('Нет комментариев'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    final c = comments[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundImage: c.avatarUrl.isNotEmpty
                              ? AnonGenerator.getAvatarImage(c.avatarUrl)
                              : null,
                          // ✅ Исправлено: используем _getInitial
                          child: c.avatarUrl.isEmpty
                              ? Text(_getInitial(c.nickname))
                              : null,
                        ),
                        title: Text(c.nickname),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(c.content),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(c.timestamp),
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Поле ввода комментария
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Написать комментарий...',
                      filled: true,
                      fillColor: Color(0xFFF0F0F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'только что';
    if (diff.inHours < 1) return '${diff.inMinutes} мин. назад';
    if (diff.inDays < 1) return '${diff.inHours} ч. назад';
    if (diff.inDays < 7) return '${diff.inDays} д. назад';
    return '${d.day}.${d.month}.${d.year}';
  }
}