import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/forum_repository.dart';
import '../../models/forum_post_model.dart';
import 'post_detail_screen.dart';
import '../../services/auth_service.dart';
import '../../utils/anon_generator.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final _controller = TextEditingController();
  bool _isPosting = false;

  void _sendPost() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);
    final repo = context.read<ForumRepository>();
    final user = context.read<AuthService>().currentUser!;

    final post = ForumPost(
      id: '',
      userId: user.uid,
      nickname: AnonGenerator.randomName(),
      avatarUrl: AnonGenerator.randomAvatar(),
      content: text,
      commentCount: 0,
      timestamp: DateTime.now(),
    );

    await repo.addForumPost(post);
    _controller.clear();
    setState(() => _isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ForumRepository>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(
        title: const Text(
          'Форум поддержки',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue[100],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 💬 Приветственный блок
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Привет 💙',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'У тебя есть какая-то проблема или мысль, которой хочешь поделиться?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // 📝 Поле для создания поста
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Поделись, что чувствуешь...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isPosting ? null : _sendPost,
                      icon: const Icon(Icons.send, size: 18),
                      label: _isPosting
                          ? const Text('Публикую...')
                          : const Text('Опубликовать'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[300],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 📜 Список постов
          Expanded(
            child: StreamBuilder<List<ForumPost>>(
              stream: repo.getForumPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return const Center(
                    child: Text(
                      'Пока нет постов.\nБудь первым, кто поделится своими мыслями 💙',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[i];
                    return ForumPostCard(post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// === Виджет для карточки поста ===
class ForumPostCard extends StatelessWidget {
  final ForumPost post;
  const ForumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Аватар + Никнейм
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    post.avatarUrl.isNotEmpty
                        ? post.avatarUrl
                        : 'assets/images/default_avatar.jpg',
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  post.nickname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 📝 Контент поста
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),

            // 📅 Дата + комментарии
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(post.timestamp),
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.blue),
                    if (post.commentCount > 0) ...[
                      const SizedBox(width: 4),
                      Text('${post.commentCount}', style: const TextStyle(fontSize: 13, color: Colors.blue)),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
