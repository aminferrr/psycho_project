import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_session_model.dart';
import '../../repositories/chat_repository.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

const _wallpapers = ['assets/wallpapers/wall1.jpg', 'assets/wallpapers/wall2.jpg', 'assets/wallpapers/wall3.jpg'];
String _wallpaperForId(String id) => _wallpapers[id.hashCode.abs() % _wallpapers.length];

/// Экран чата с волонтёром (для пользователя или для психолога — ответы)
class VolunteerChatScreen extends StatefulWidget {
  final String chatId;
  final String peerName;
  final bool isPsychologist;

  const VolunteerChatScreen({
    Key? key,
    required this.chatId,
    required this.peerName,
    this.isPsychologist = false,
  }) : super(key: key);

  @override
  State<VolunteerChatScreen> createState() => _VolunteerChatScreenState();
}

class _VolunteerChatScreenState extends State<VolunteerChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId == null) return;

    final msg = ChatMessage(
      role: widget.isPsychologist ? 'assistant' : 'user',
      content: text,
      timestamp: DateTime.now(),
    );
    await context.read<ChatRepository>().addVolunteerChatMessage(widget.chatId, msg);
  }

  @override
  Widget build(BuildContext context) {
    final chatRepo = context.read<ChatRepository>();

    final wallpaper = _wallpaperForId(widget.chatId);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerName.isNotEmpty ? widget.peerName : 'Чат'),
        backgroundColor:Color(0xFF3E2C4A),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(wallpaper, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.92)),
          ),
          StreamBuilder<VolunteerChatSession?>(
            stream: chatRepo.getVolunteerChatSession(widget.chatId),
            builder: (context, snapshot) {
              final session = snapshot.data;
              final canReply = widget.isPsychologist || (session?.status == 'accepted' ?? false);

              return Column(
                children: [
                  Expanded(
                    child: _buildMessages(snapshot),
                  ),
                  if (canReply) _buildInput(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(AsyncSnapshot<VolunteerChatSession?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    final session = snapshot.data;
    if (session == null) {
      return const Center(child: Text('Чат не найден'));
    }
    final messages = session.messages;
    if (messages.isEmpty) {
      return Center(
        child: Text(
          widget.isPsychologist
              ? 'Напишите ответ пользователю'
              : session.status == 'pending'
              ? 'Ожидайте принятия запроса психологом'
              : 'Напишите сообщение волонтёру',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final msg = messages[i];
        final isUser = msg.role == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? Color(0xFF3E2C4A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Text(
              msg.content,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Сообщение...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _send,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}