import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miloo_mobile/services/auth_service.dart';
import 'package:miloo_mobile/models/user_register_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String? _refreshToken;
  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _forgotPasswordError;
  String? get forgotPasswordError => _forgotPasswordError;

  Future<bool> register(UserRegisterModel registerModel) async {
    final success = await _authService.register(registerModel: registerModel);
    return success;
  }

  Future<bool> verifyEmail(String email, String code) async {
    final success = await _authService.verifyEmail(email: email, code: code);
    return success;
  }

  Future<bool> login(String email, String password, bool isRemember) async {
    try {
      final success = await _authService.login(
          email: email, password: password, isRemember: isRemember);
      if (success) {
        _isAuthenticated = true;
        _accessToken = await _authService.getAccessToken();
        _refreshToken = await _storage.read(key: 'refreshToken');
        notifyListeners();
      }
      return success;
    } catch (e) {
      _isAuthenticated = false;
      _accessToken = null;
      _refreshToken = null;
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isAuthenticated = false;
      _accessToken = null;
      _refreshToken = null;
      await _storage.deleteAll();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      _forgotPasswordError = null;
      await _authService.forgotPassword(email);
    } catch (e) {
      _forgotPasswordError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkAuthentication() async {
    _accessToken = await _storage.read(key: 'accessToken');
    _refreshToken = await _storage.read(key: 'refreshToken');
    _isAuthenticated = _accessToken != null && _refreshToken != null;
    notifyListeners();
  }
}
