// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/ai_service.dart';

import '../repositories/emotion_repository.dart';
import '../repositories/food_repository.dart';
import '../repositories/forum_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/practice_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_stats_repository.dart';

import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // === СЕРВИСЫ ===
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => AIService()), // ЧАТ С ИИ

        // === РЕПОЗИТОРИИ ===
        Provider<EmotionRepository>(
          create: (context) => EmotionRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<FoodRepository>(
          create: (context) => FoodRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<ForumRepository>(
          create: (context) => ForumRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<ChatRepository>(
          create: (context) => ChatRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<PracticeRepository>(
          create: (context) => PracticeRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<UserRepository>(
          create: (context) => UserRepository(
            Provider.of<FirestoreService>(context, listen: false),
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        Provider<UserStatsRepository>(
          create: (context) => UserStatsRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Mind Care',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // или .light / .dark
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// === АВТОПЕРЕХОД: Вход / Главная ===
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Загрузка...'),
                ],
              ),
            ),
          );
        }

        return snapshot.data != null ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}