import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:construct_manager/l10n/app_localizations.dart';
import 'package:construct_manager/presentation/auth/login_screen.dart';

Widget createTestApp() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: const LoginScreen(),
  );
}

void main() {
  testWidgets('LoginScreen displays login form', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();

    expect(find.byIcon(Icons.construction), findsOneWidget);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors on empty submit',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Invalid email format'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });
}
