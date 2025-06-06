import 'package:flutter/material.dart';
import 'package:mobile_app/data/user_remote_datasource.dart';
import '../model/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRemoteDataSource _authService = AuthRemoteDataSource();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> register(String name, String email, String password, String role) async {
    _setLoading(true);
    try {
      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email: email, password: password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
