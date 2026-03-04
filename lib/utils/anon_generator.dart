import 'dart:math';
import 'package:flutter/material.dart';

class AnonGenerator {
  static final List<Map<String, String>> _pairs = [
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

  static final Random _random = Random();

  /// Возвращает случайную пару: имя и аватар
  static Map<String, String> randomProfile() {
    final pair = _pairs[_random.nextInt(_pairs.length)];
    return {
      'name': pair['name'] ?? 'Аноним',  // ← добавляем ?? для безопасности
      'avatar': pair['avatar'] ?? 'assets/images/default_avatar.jpg',  // ← добавляем ??
    };
  }

  /// Возвращает случайное имя
  static String randomName() {
    final profile = randomProfile();
    return profile['name'] ?? 'Аноним';
  }

  /// Возвращает случайный путь к аватару
  static String randomAvatar() {
    final profile = randomProfile();
    return profile['avatar'] ?? 'assets/images/default_avatar.jpg';
  }

  /// Получить ImageProvider для аватара
  static ImageProvider getAvatarImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return NetworkImage(imagePath);
      } else {
        return AssetImage(imagePath);
      }
    }
    return const AssetImage('assets/images/default_avatar.jpg');
  }

  /// Создать CircleAvatar с правильным ImageProvider
  static Widget buildAvatar(String? imagePath, {double radius = 20, String? name}) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: imagePath != null && imagePath.isNotEmpty
          ? (imagePath.startsWith('http')
          ? NetworkImage(imagePath) as ImageProvider
          : AssetImage(imagePath))
          : null,
      backgroundColor: Colors.grey[300],
      child: (imagePath == null || imagePath.isEmpty)
          ? Text(
        (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '?',
        style: TextStyle(fontSize: radius * 0.8),
      )
          : null,
    );
  }
}