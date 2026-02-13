import 'package:flutter_test/flutter_test.dart';
import 'package:psychologist_app/utils/constants.dart';

void main() {
  test('App name is MindCare', () {
    expect(AppConstants.appName, 'MindCare');
  });

  test('Firestore collections constants are not empty', () {
    expect(AppConstants.usersCollection.isNotEmpty, true);
    expect(AppConstants.forumPostsCollection.isNotEmpty, true);
    expect(AppConstants.emotionEntriesCollection.isNotEmpty, true);
    expect(AppConstants.foodEntriesCollection.isNotEmpty, true);
  });
}
