import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/forum_post_model.dart';
import '../../repositories/forum_repository.dart';
import '../../services/auth_service.dart';
import '../../utils/anon_generator.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _controller = TextEditingController();
  bool _isPosting = false;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ForumRepository>();
    final user = context.read<AuthService>().currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Новый пост')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Поделитесь своими мыслями...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isPosting
                  ? null
                  : () async {
                final text = _controller.text.trim();
                if (text.isEmpty) return;

                setState(() => _isPosting = true);

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
                setState(() => _isPosting = false);
                Navigator.pop(context);
              },
              child: _isPosting
                  ? const CircularProgressIndicator()
                  : const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }
}
