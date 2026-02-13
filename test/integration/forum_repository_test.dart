import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:psychologist_app/repositories/forum_repository.dart';
import 'package:psychologist_app/services/firestore_service.dart';
import 'package:psychologist_app/models/forum_post_model.dart';
import 'package:psychologist_app/models/forum_comment_model.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

class FakeForumPost extends Fake implements ForumPost {}
class FakeForumComment extends Fake implements ForumComment {}

void main() {
  late MockFirestoreService service;
  late ForumRepository repo;

  setUpAll(() {
    registerFallbackValue(FakeForumPost());
    registerFallbackValue(FakeForumComment());
  });

  setUp(() {
    service = MockFirestoreService();
    repo = ForumRepository(service);
  });

  test('addForumPost delegates to FirestoreService and returns id', () async {
    when(() => service.addForumPost(any())).thenAnswer((_) async => 'postId123');

    final id = await repo.addForumPost(FakeForumPost());

    expect(id, 'postId123');
    verify(() => service.addForumPost(any())).called(1);
  });

  test('getForumPosts delegates and returns same stream', () async {
    final stream = Stream<List<ForumPost>>.value(<ForumPost>[FakeForumPost()]);
    when(() => service.getForumPosts()).thenAnswer((_) => stream);

    final res = repo.getForumPosts();

    expect(res, stream);
    verify(() => service.getForumPosts()).called(1);
  });

  test('addForumComment delegates to FirestoreService', () async {
    when(() => service.addForumComment(any())).thenAnswer((_) async {});

    await repo.addForumComment(FakeForumComment());

    verify(() => service.addForumComment(any())).called(1);
  });
}
