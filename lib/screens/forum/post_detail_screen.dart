import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/forum_post_model.dart';
import '../../models/forum_comment_model.dart';
import '../../repositories/forum_repository.dart';
import '../../services/auth_service.dart';

class PostDetailScreen extends StatefulWidget {
  final ForumPost post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    final user = context.read<AuthService>().currentUser!;
    final comment = ForumComment(
      id: '',
      postId: widget.post.id,
      userId: user.uid,
      content: text,
      timestamp: DateTime.now(),
    );
    context.read<ForumRepository>().addForumComment(comment);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ForumRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Пост')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.post.content, style: const TextStyle(fontSize: 18)),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<ForumComment>>(
              stream: repo.getForumComments(widget.post.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final comments = snapshot.data!;
                if (comments.isEmpty) return const Center(child: Text('Нет комментариев'));

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    final c = comments[i];
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(c.content),
                      subtitle: Text(_formatTime(c.timestamp)),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Напишите комментарий...',
                      filled: true,
                      fillColor: Color(0xFFF0F0F0),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _send,
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
    if (diff.inHours < 1) return '${diff.inMinutes} мин';
    return '${diff.inHours} ч';
  }
}
