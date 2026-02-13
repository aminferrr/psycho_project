import '../models/chat_session_model.dart';
import '../services/firestore_service.dart';

class ChatRepository {
  final FirestoreService _firestoreService;

  ChatRepository(this._firestoreService);

  Stream<List<ChatSession>> getUserChatSessions(String userId) {
    return _firestoreService.getUserChatSessions(userId);
  }

  Future<String> createChatSession(String userId, String initialMessage) async {
    return await _firestoreService.createChatSession(userId, initialMessage);
  }

  Future<void> addMessageToChat(String userId, String sessionId, ChatMessage message) async {
    await _firestoreService.addMessageToChat(userId, sessionId, message);
  }

  Stream<ChatSession?> getChatSession(String userId, String sessionId) {
    return _firestoreService.getChatSession(userId, sessionId);
  }

}