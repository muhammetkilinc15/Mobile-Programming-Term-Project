import 'package:flutter/foundation.dart';
import 'package:miloo_mobile/services/auth_service.dart';
import 'package:miloo_mobile/models/user_register_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _accessToken;
  String? get accessToken => _accessToken;

  Future<bool> register(UserRegisterModel registerModel) async {
    final success = await _authService.register(registerModel: registerModel);
    return success;
  }

  Future<bool> verifyEmail(String email, String code) async {
    final success = await _authService.verifyEmail(email: email, code: code);
    return success;
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email: email, password: password);
    if (success) {
      _isAuthenticated = true;
      _accessToken = await _authService.getAccessToken();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _accessToken = null;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }

  Future<void> checkAuthentication() async {
    _accessToken = await _authService.getAccessToken();
    _isAuthenticated = _accessToken != null;
    notifyListeners();
  }
}
