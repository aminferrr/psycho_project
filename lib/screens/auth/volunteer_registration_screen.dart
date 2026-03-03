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

  bool _hasPsychologyEducation = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анкета волонтера'),
        backgroundColor: Colors.teal,
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
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'ФИО *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Возраст *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Образование *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Специализация *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Опыт работы *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _motivationController,
                decoration: const InputDecoration(
                  labelText: 'Мотивация *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizationController,
                decoration: const InputDecoration(
                  labelText: 'Организация (если есть)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Имею психологическое образование'),
                value: _hasPsychologyEducation,
                onChanged: (v) => setState(() => _hasPsychologyEducation = v!),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Отправить заявку'),
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
      final profile = VolunteerProfile(
        id: '',
        userId: uid,
        fullName: _fullNameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        education: _educationController.text.trim(),
        specialization: _specializationController.text.trim(),
        experience: _experienceController.text.trim(),
        motivation: _motivationController.text.trim(),
        certificates: [],
        hasPsychologyEducation: _hasPsychologyEducation,
        organization: _organizationController.text.trim().isEmpty
            ? null
            : _organizationController.text.trim(),
        appliedAt: DateTime.now(),
        status: VolunteerStatus.pending,
      );
      await volunteerRepo.submitApplication(profile);

      final user = await userRepo.currentUser.first;
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
          volunteerId: null,
          adminPermissions: user.adminPermissions,
        );
        await userRepo.updateUser(updated);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заявка отправлена на рассмотрение!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}