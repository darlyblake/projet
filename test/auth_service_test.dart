import 'package:flutter_test/flutter_test.dart';

// Simulation locale d'AuthService pour le test
class AuthService {
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}

void main() {
  group('AuthService', () {
    final authService = AuthService();

    test('should return true when email is valid', () {
      final result = authService.validateEmail('test@example.com');
      expect(result, true);
    });

    test('should return false when email is invalid', () {
      final result = authService.validateEmail('invalidemail');
      expect(result, false);
    });
  });
}
