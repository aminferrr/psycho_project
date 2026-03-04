import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> authenticate() async {
    if (isLoading) return;

    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || !email.contains('@')) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'Введите корректный email',
        );
      }

      if (password.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'Пароль должен быть не менее 6 символов',
        );
      }

      final authService = Provider.of<AuthService>(context, listen: false);

      if (isLogin) {
        await authService.signInWithEmailAndPassword(email, password);
      } else {
        final name = nameController.text.trim();
        if (name.isEmpty) {
          throw FirebaseAuthException(
            code: 'invalid-name',
            message: 'Введите ваше имя',
          );
        }

        await authService.registerWithEmailAndPassword(email, password, name);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Этот email уже используется';
          break;
        case 'invalid-email':
          errorMessage = 'Неверный формат email';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password вход не включен';
          break;
        case 'weak-password':
          errorMessage = 'Пароль слишком слабый';
          break;
        case 'user-not-found':
          errorMessage = 'Пользователь не найден';
          break;
        case 'wrong-password':
          errorMessage = 'Неверный пароль';
          break;
        default:
          errorMessage = e.message ?? 'Произошла ошибка';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB39EB5),
              Color(0xFFD1C4E9),
              Color(0xFFF3E5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Mind Care',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Забота о вашем ментальном здоровье',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              isLogin ? 'Вход' : 'Регистрация',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            if (!isLogin)
                              Column(
                                children: [
                                  TextField(
                                    key: const Key('register_name'),
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Ваше имя',
                                      prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),

                            TextField(
                              key: const Key('login_email'),
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              key: const Key('login_password'),
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Пароль',
                                prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                key: const Key('login_button'),
                                onPressed: isLoading ? null : authenticate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                                    : Text(
                                  isLogin ? 'Войти' : 'Зарегистрироваться',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      key: const Key('toggle_auth_mode'),
                      onPressed: isLoading
                          ? null
                          : () {
                        if (mounted) {
                          setState(() => isLogin = !isLogin);
                        }
                      },
                      child: Text(
                        isLogin
                            ? 'Нет аккаунта? Создать'
                            : 'Уже есть аккаунт? Войти',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/volunteer_register'),
                      child: const Text(
                        'Регистрация как волонтёр',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
