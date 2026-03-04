import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../repositories/volunteer_repository.dart';
import '../../repositories/user_repository.dart';
import '../../models/volunteer_profile_model.dart';
import '../../models/user_model.dart';

class VolunteerRegistrationScreen extends StatefulWidget {
  const VolunteerRegistrationScreen({Key? key}) : super(key: key);

  @override
  _VolunteerRegistrationScreenState createState() => _VolunteerRegistrationScreenState();
}

class _VolunteerRegistrationScreenState extends State<VolunteerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _educationController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _motivationController = TextEditingController();
  final _organizationController = TextEditingController();
  final _phoneController = TextEditingController(); // Новое поле

  bool _hasPsychologyEducation = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анкета волонтера'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Заполните анкету для регистрации в качестве волонтера',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ФИО
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'ФИО *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Возраст
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Возраст *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Обязательное поле';
                  if (int.tryParse(v) == null) return 'Введите число';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Образование
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Образование *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                maxLines: 2,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Специализация
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Специализация *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.psychology),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Опыт работы
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Опыт работы *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Мотивация
              TextFormField(
                controller: _motivationController,
                decoration: const InputDecoration(
                  labelText: 'Мотивация *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              // Организация (необязательно)
              TextFormField(
                controller: _organizationController,
                decoration: const InputDecoration(
                  labelText: 'Организация (если есть)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),

              // НОМЕР ТЕЛЕФОНА
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+7 (999) 123-45-67',
                ),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Обязательное поле';
                  }
                  // Простая проверка номера телефона
                  if (v.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                    return 'Введите корректный номер телефона';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Психологическое образование
              CheckboxListTile(
                title: const Text('Имею психологическое образование'),
                value: _hasPsychologyEducation,
                onChanged: (v) => setState(() => _hasPsychologyEducation = v!),
              ),
              const SizedBox(height: 16),

              // Информация о собеседовании
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Что дальше?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'После отправки заявки администратор свяжется с вами по указанному номеру телефона для проведения собеседования.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Кнопка отправки
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Отправить заявку на собеседование',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    final volunteerRepo = context.read<VolunteerRepository>();
    final userRepo = context.read<UserRepository>();
    final auth = context.read<AuthService>();
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите в аккаунт')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Создаем профиль с номером телефона
      final profile = VolunteerProfile(
        id: uid,
        userId: uid,
        fullName: _fullNameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        education: _educationController.text.trim(),
        specialization: _specializationController.text.trim(),
        experience: _experienceController.text.trim(),
        motivation: _motivationController.text.trim(),
        organization: _organizationController.text.trim().isEmpty
            ? null
            : _organizationController.text.trim(),
        photoUrl: null,
        hasPsychologyEducation: _hasPsychologyEducation,
        status: VolunteerStatus.pending,
        appliedAt: DateTime.now(),
        phoneNumber: _phoneController.text.trim(),
      );

      await volunteerRepo.submitApplication(profile);

      // Обновляем роль пользователя
      final user = await userRepo.getUser(uid);
      if (user != null) {
        final updated = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName ?? profile.fullName,
          photoURL: user.photoURL,
          createdAt: user.createdAt,
          lastLogin: user.lastLogin,
          subscription: user.subscription,
          settings: user.settings,
          role: UserRole.volunteer,
          isApproved: false,
          volunteerApplicationDate: DateTime.now(),
          volunteerId: uid,
          adminPermissions: user.adminPermissions,
        );
        await userRepo.updateUser(updated);
      }

      if (!mounted) return;

      // Показываем сообщение
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заявка отправлена! Администратор свяжется с вами по номеру ${_phoneController.text.trim()}'),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );

      // Переходим на экран ожидания
      Navigator.pushReplacementNamed(context, '/waiting-approval');

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _educationController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _motivationController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}