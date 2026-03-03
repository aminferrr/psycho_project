import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../helpline_screen.dart';
import '../auth/volunteer_registration_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: SingleChildScrollView(  // ← Оборачиваем в SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Карточка пользователя
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    if (user != null) ...[
                      Text(
                        user.email ?? 'Пользователь',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Зарегистрирован: ${user.metadata.creationTime?.toString().split(' ')[0] ?? 'Неизвестно'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Настройки
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(Icons.volunteer_activism, 'Стать волонтёром', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VolunteerRegistrationScreen()),
                    );
                  }),
                  _buildSettingsItem(Icons.notifications, 'Уведомления', () {}),
                  _buildSettingsItem(Icons.privacy_tip, 'Конфиденциальность', () {}),
                  _buildSettingsItem(Icons.phone_in_talk, 'Телефон доверия', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelplineScreen()),
                    );
                  }),
                  _buildSettingsItem(Icons.help, 'Помощь', () {}),
                  _buildSettingsItem(Icons.info, 'О приложении', () {}),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Выход
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Выйти из аккаунта'),
              ),
            ),
            // Добавляем отступ снизу для удобства прокрутки
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}