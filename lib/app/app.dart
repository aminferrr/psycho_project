// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';

import '../repositories/emotion_repository.dart';
import '../repositories/food_repository.dart';
import '../repositories/forum_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/practice_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_stats_repository.dart';
import '../repositories/volunteer_repository.dart';
import '../repositories/admin_repository.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/volunteer_registration_screen.dart';
import '../screens/auth/waiting_for_approval_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/psychologist_home_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../models/user_model.dart';

// Эти импорты уже включены в предыдущие
// import '../screens/admin/volunteer_applications_screen.dart';
// import '../screens/admin/practices_management_screen.dart';
// и т.д. - они не нужны здесь, так как используются внутри admin_dashboard_screen

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // === СЕРВИСЫ ===
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => AIService()),
        Provider(create: (_) => StorageService()),

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
        Provider<VolunteerRepository>(
          create: (context) => VolunteerRepository(
            Provider.of<FirestoreService>(context, listen: false),
            Provider.of<StorageService>(context, listen: false),
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        Provider<AdminRepository>(
          create: (context) => AdminRepository(
            Provider.of<FirestoreService>(context, listen: false),
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Mind Care',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/volunteer_register': (context) => const VolunteerRegistrationScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}

// === АВТОПЕРЕХОД ПО РОЛЯМ ===
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRepo = Provider.of<UserRepository>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const LoginScreen();
        }

        return StreamBuilder<UserModel?>(
          stream: userRepo.currentUser,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = userSnapshot.data;

            if (user == null) {
              return const LoginScreen();
            }

            // Маршрутизация по ролям
            switch (user.role) {
              case UserRole.admin:
                return const AdminDashboardScreen();

              case UserRole.psychologist:
                return const PsychologistHomeScreen();

              case UserRole.volunteer:
                if (!user.isApproved) {
                  return const WaitingForApprovalScreen();
                }
                return const HomeScreen();

              case UserRole.user:
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}