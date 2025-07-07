import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  final AuthService _authService = AuthService();

  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password, UserRole role) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.login(email, password);

      // Vérifie le rôle
      if (user.role != role.name) {
        _setErrorMessage('Rôle utilisateur invalide pour cette connexion.');
        _setLoading(false);
        return false;
      }

      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage(_convertAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(
      String name, String email, String password, UserRole role) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authService.register(name, email, password, role);
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage(_convertAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle(UserRole role) async {
    _setLoading(true);
    _clearError();

    try {
      if (kIsWeb) {
        // Sur web, le bouton natif doit être utilisé → ne pas appeler signIn ici
        _setErrorMessage(
            'Utilisez le bouton Google natif affiché ci-dessous pour vous connecter.');
        return false;
      }

      final user = await _authService.signInWithGoogle(role);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage(_convertAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _convertAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email non enregistré';
        case 'wrong-password':
          return 'Mot de passe incorrect';
        case 'email-already-in-use':
          return 'Email déjà utilisé';
        case 'role-mismatch':
          return 'Ce compte est déjà associé à un autre rôle';
        default:
          return 'Erreur lors de l\'authentification';
      }
    }
    return e.toString();
  }

  Future<bool> loginWithGoogleWebJwt(String jwt, UserRole role) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signInWithGoogleWeb(jwt, role);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage(_convertAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
