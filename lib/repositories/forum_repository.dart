import '../models/forum_post_model.dart';
import '../models/forum_comment_model.dart';
import '../services/firestore_service.dart';

class ForumRepository {
  final FirestoreService _firestoreService;

  ForumRepository(this._firestoreService);

  Stream<List<ForumPost>> getForumPosts({int limit = 20}) {
    return _firestoreService.getForumPosts(limit: limit);
  }

  Future<String> addForumPost(ForumPost post) async {
    return await _firestoreService.addForumPost(post);
  }

  Future<void> addForumComment(ForumComment comment) async {
    await _firestoreService.addForumComment(comment);
  }

  Stream<List<ForumComment>> getForumComments(String postId) {
    return _firestoreService.getForumComments(postId);
  }
}