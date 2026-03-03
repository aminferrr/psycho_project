import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/chat_repository.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'volunteer_chat_screen.dart';

/// Экран запросов на переписку для психолога (волонтёра)
class PsychologistRequestsScreen extends StatelessWidget {
  const PsychologistRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text('Войдите в аккаунт'));
    }

    final chatRepo = context.watch<ChatRepository>();

    return StreamBuilder<List<VolunteerChatSession>>(
      stream: chatRepo.getVolunteerChats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final allChats = snapshot.data ?? [];
        final pending = allChats.where((c) => c.status == 'pending').toList();

        if (pending.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Нет новых запросов на переписку',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pending.length,
          itemBuilder: (context, index) {
            final chat = pending[index];
            final lastMsg = chat.messages.isNotEmpty
                ? chat.messages.last.content
                : 'Запрос на переписку';
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(
                    chat.volunteerName.isNotEmpty ? chat.volunteerName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chat.userName?.isNotEmpty == true ? chat.userName! : 'Пользователь'),
                subtitle: Text(
                  lastMsg.length > 60 ? '${lastMsg.substring(0, 60)}...' : lastMsg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _acceptAndOpen(context, chat.id),
                      child: const Text('Принять'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VolunteerChatScreen(
                            chatId: chat.id,
                            peerName: chat.userName?.isNotEmpty == true ? chat.userName! : 'Пользователь',
                            isPsychologist: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _acceptAndOpen(BuildContext context, String chatId) async {
    await context.read<ChatRepository>().acceptVolunteerChatRequest(chatId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Запрос принят')),
      );
    }
  }
}
