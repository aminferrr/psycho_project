import 'package:flutter_test/flutter_test.dart';
import 'package:psychologist_app/utils/anon_generator.dart';

void main() {
  test('randomProfile returns name and avatar', () {
    final p = AnonGenerator.randomProfile();
    expect(p.containsKey('name'), true);
    expect(p.containsKey('avatar'), true);
    expect(p['name']!.isNotEmpty, true);
    expect(p['avatar']!.isNotEmpty, true);
  });

  test('randomAvatar returns assets path', () {
    final avatar = AnonGenerator.randomAvatar();
    expect(avatar.startsWith('assets/images/'), true);
    expect(avatar.endsWith('.jpg'), true);
  });
}
