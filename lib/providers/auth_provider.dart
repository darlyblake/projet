import 'package:flutter/material.dart';
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

  Future<bool> login(String email, String password, UserRole role) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.login(email, password, role);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
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
      final user = await _authService.register(name, email, password, role);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _currentUser = null;
    _authService.logout();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
