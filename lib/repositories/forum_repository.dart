import '../models/forum_post_model.dart';
import '../models/forum_comment_model.dart';
import '../services/firestore_service.dart';

class ForumRepository {
  final FirestoreService _firestoreService;

  ForumRepository(this._firestoreService);

  Stream<List<ForumPost>> getForumPosts() =>
      _firestoreService.getForumPosts();

  Future<String> addForumPost(ForumPost post) =>
      _firestoreService.addForumPost(post);

  Stream<List<ForumComment>> getForumComments(String postId) =>
      _firestoreService.getForumComments(postId);

  Future<void> addForumComment(ForumComment comment) =>
      _firestoreService.addForumComment(comment);
}
