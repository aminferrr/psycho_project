import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/forum_post_model.dart';
import '../../repositories/forum_repository.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/forum_post_card.dart';

class ForumModerationScreen extends StatefulWidget {
  const ForumModerationScreen({Key? key}) : super(key: key);

  @override
  _ForumModerationScreenState createState() => _ForumModerationScreenState();
}

class _ForumModerationScreenState extends State<ForumModerationScreen> {
  @override
  Widget build(BuildContext context) {
    final forumRepo = Provider.of<ForumRepository>(context);
    final adminRepo = Provider.of<AdminRepository>(context);

    return StreamBuilder<List<ForumPost>>(
      stream: forumRepo.getForumPosts(limit: 50),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ForumPostCard(post: post),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.warning, color: Colors.orange),
                        label: const Text('Пожаловаться'),
                        onPressed: () {},
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Удалить'),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Удалить пост'),
                              content: const Text('Вы уверены?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await adminRepo.deletePost(post.id, post.userId);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}