import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'package:psychologist_app/screens/auth/login_screen.dart';
import 'package:psychologist_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen shows title and button', (tester) async {
    final auth = MockAuthService();

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: auth,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mind Care'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });

  testWidgets('Invalid email shows snackbar error', (tester) async {
    final auth = MockAuthService();

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: auth,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_email')), 'bad');
    await tester.enterText(find.byKey(const Key('login_password')), '123456');

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(); // старт snackbar
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Неверный формат email'), findsOneWidget);
  });

  testWidgets('Switch to register mode shows name field', (tester) async {
    final auth = MockAuthService();

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: auth,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('toggle_auth_mode')));
    await tester.pumpAndSettle();

    expect(find.text('Регистрация'), findsOneWidget);
    expect(find.byKey(const Key('register_name')), findsOneWidget);
  });
}
