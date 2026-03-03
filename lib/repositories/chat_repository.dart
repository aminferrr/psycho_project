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

  // --- Чаты с волонтёрами ---
  Stream<List<VolunteerChatSession>> getUserVolunteerChats(String userId) {
    return _firestoreService.getUserVolunteerChats(userId);
  }

  Stream<List<VolunteerChatSession>> getVolunteerChats(String volunteerUserId) {
    return _firestoreService.getVolunteerChats(volunteerUserId);
  }

  Future<String> createOrGetVolunteerChat(String userId, String volunteerUserId, String volunteerName, {String? userName}) async {
    return _firestoreService.createOrGetVolunteerChat(userId, volunteerUserId, volunteerName, userName: userName);
  }

  Stream<VolunteerChatSession?> getVolunteerChatSession(String chatId) {
    return _firestoreService.getVolunteerChatSession(chatId);
  }

  Future<void> addVolunteerChatMessage(String chatId, ChatMessage message) async {
    await _firestoreService.addVolunteerChatMessage(chatId, message);
  }

  Future<void> acceptVolunteerChatRequest(String chatId) async {
    await _firestoreService.acceptVolunteerChatRequest(chatId);
  }
}