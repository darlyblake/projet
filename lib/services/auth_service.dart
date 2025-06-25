import 'package:edustore/models/user_model.dart';

class AuthService {
  // Simulation d'une API
  Future<UserModel> login(String email, String password, UserRole role) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation réseau

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email et mot de passe requis');
    }

    return UserModel(
      id: 1,
      name: 'Utilisateur Test',
      email: email,
      role: role,
      joinDate: DateTime.now(),
    );
  }

  Future<UserModel> register(
      String name, String email, String password, UserRole role) async {
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Tous les champs sont requis');
    }

    return UserModel(
      id: 1,
      name: name,
      email: email,
      role: role,
      joinDate: DateTime.now(),
    );
  }

  void logout() {
    // Nettoyage des données locales
  }
}
