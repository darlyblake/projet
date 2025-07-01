import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edustore/screens/auth/login_screen.dart';
import 'package:edustore/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/auth_provider.dart';

void main() {
  testWidgets('LoginScreen has email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MaterialApp(
          home: LoginScreen(userRole: UserRole.student),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2)); // Email + Password
    expect(find.text('Connexion'), findsOneWidget); // Bouton "Connexion"
  });
}
