import 'dart:math';

class AnonGenerator {
  static final _pairs = [
    {'name': 'Весёлый Ёжик', 'avatar': 'assets/images/dreaminghedgehog.jpg'},
    {'name': 'Сонный Котик', 'avatar': 'assets/images/sleepycat.jpg'},
    {'name': 'Мечтательная Овца', 'avatar': 'assets/images/softsheep.jpg'},
    {'name': 'Ленивый Щенок', 'avatar': 'assets/images/lazypuppy.jpg'},
    {'name': 'Милый Панда', 'avatar': 'assets/images/cuteredpanda.jpg'},
    {'name': 'Радостная Выдра', 'avatar': 'assets/images/cheerfulotter.jpg'},
    {'name': 'Философский Медвежонок', 'avatar': 'assets/images/moehahahah.jpg'},
    {'name': 'Воздушный Поросёнок', 'avatar': 'assets/images/beautifulpig.jpg'},
    {'name': 'Пушистая Шиншилла', 'avatar': 'assets/images/fluffychinchilla.jpg'},
    {'name': 'Полярный Мечтатель', 'avatar': 'assets/images/tiredpolarbear.jpg'},
  ];

  static final _random = Random();

  /// Возвращает случайную пару: имя и аватар
  static Map<String, String> randomProfile() {
    final pair = _pairs[_random.nextInt(_pairs.length)];
    return {
      'name': pair['name']!,
      'avatar': pair['avatar']!,
    };
  }

  /// Для обратной совместимости, если тебе нужны отдельно методы
  static String randomName() => randomProfile()['name']!;
  static String randomAvatar() => randomProfile()['avatar']!;
}
