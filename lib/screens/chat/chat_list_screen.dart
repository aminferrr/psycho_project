import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/volunteer_profile_model.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/volunteer_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/auth_service.dart';
import 'ai_chat_screen.dart';
import 'volunteer_chat_screen.dart';


class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static const List<String> _wallpapers = [
    'assets/wallpapers/wall1.jpg',
    'assets/wallpapers/wall2.jpg',
    'assets/wallpapers/wall3.jpg',
  ];

  static String wallpaperForId(String id) {
    final index = id.hashCode.abs() % _wallpapers.length;
    return _wallpapers[index];
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Войдите в аккаунт')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChatTile(
            title: 'Чат с психологом (ИИ)',
            subtitle: 'Поддержка 24/7',
            icon: Icons.psychology,
            wallpaper: wallpaperForId('ai'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AIChatScreen()),
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<VolunteerProfile>>(
            stream: context.watch<VolunteerRepository>().getApprovedVolunteers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final volunteers = snapshot.data ?? [];


              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: volunteers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final v = volunteers[index];
                  return _ChatTile(
                    title: v.fullName,
                    subtitle: v.specialization,
                    icon: Icons.person,
                    wallpaper: wallpaperForId('vol_${v.id}'),
                    onTap: () => _openVolunteerChat(context, v),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openVolunteerChat(BuildContext context, VolunteerProfile volunteer) async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId == null) return;

    final userSnapshot = await context.read<UserRepository>().currentUser.first;
    final userName = userSnapshot?.displayName ?? userSnapshot?.email ?? 'Пользователь';

    final chatRepo = context.read<ChatRepository>();
    final chatId = await chatRepo.createOrGetVolunteerChat(
      userId,
      volunteer.userId,
      volunteer.fullName,
      userName: userName,
    );

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VolunteerChatScreen(
          chatId: chatId,
          peerName: volunteer.fullName,
          isPsychologist: false,
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String wallpaper;
  final VoidCallback onTap;

  const _ChatTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.wallpaper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100, // ← Добавьте фиксированную высоту
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect( // ← Добавьте ClipRRect для скругления
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Изображение фона
                Image.asset(
                  wallpaper,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                ),
                // Градиент
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Контент
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(icon, size: 32, color: Color(0xFF3E2C4A)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // ← уже есть, хорошо
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 14,
                                shadows: const [Shadow(color: Colors.black54, blurRadius: 2)],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white, size: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}