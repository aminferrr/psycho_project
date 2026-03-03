import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/chat_repository.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'volunteer_chat_screen.dart';

/// Список всех чатов психолога (волонтёра) с пользователями
class PsychologistChatListScreen extends StatelessWidget {
  const PsychologistChatListScreen({Key? key}) : super(key: key);

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

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Пока нет чатов. Новые запросы появятся здесь.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final lastMsg = chat.messages.isNotEmpty
                ? chat.messages.last.content
                : (chat.status == 'pending' ? 'Ожидает принятия' : 'Нет сообщений');
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: chat.status == 'pending' ? Colors.orange : Colors.teal,
                  child: Text(
                    chat.volunteerName.isNotEmpty ? chat.volunteerName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chat.userName?.isNotEmpty == true ? chat.userName! : 'Пользователь'),
                subtitle: Text(
                  lastMsg.length > 50 ? '${lastMsg.substring(0, 50)}...' : lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: chat.status == 'pending'
                    ? const Chip(label: Text('Новый'), backgroundColor: Colors.orange)
                    : const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
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
            );
          },
        );
      },
    );
  }
}
