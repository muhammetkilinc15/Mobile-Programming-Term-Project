import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'dart:convert';
import 'package:miloo_mobile/models/user_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String url = "${baseUrl}auth/";
  final storage = const FlutterSecureStorage();

  Future<bool> register({required UserRegisterModel registerModel}) async {
    final response = await http.post(
      Uri.parse("${url}register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(registerModel.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse("${url}verify-email"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "email": email,
        "code": code,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse("${url}refresh-token"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "refreshToken": refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);

      // Yeni tokenları güvenli saklayın
      await storage.write(key: "accessToken", value: body["accessToken"]);
      await storage.write(key: "refreshToken", value: body["refreshToken"]);
      await storage.write(key: "tokenExpiration", value: body["expiration"]);

      return body["accessToken"];
    }
    return null;
  }

  Future<void> forgotPassword(String email) async {
    await http.post(
      Uri.parse("${url}forgot-password"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "email": email,
      }),
    );
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse("${url}login"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "usernameOrEmail": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        // Store tokens securely
        await Future.wait([
          storage.write(key: "accessToken", value: body["accessToken"]),
          storage.write(key: "refreshToken", value: body["refreshToken"]),
          storage.write(key: "tokenExpiration", value: body["expiration"]),
        ]);

        // Verify token storage
        final storedToken = await storage.read(key: "accessToken");
        if (storedToken == null) {
          throw Exception("Failed to store access token");
        }

        final prefs = await SharedPreferences.getInstance();
        String profileImage =
            JwtDecoder.decode(body["accessToken"])["profileImage"];
        await prefs.setString("profileImage", profileImage);

        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token == null) {
        // Try refresh token
        final refreshToken = await storage.read(key: "refreshToken");
        if (refreshToken != null) {
          return await refreshAccessToken(refreshToken);
        }
        throw Exception("No access token found");
      }

      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        final refreshToken = await storage.read(key: "refreshToken");
        if (refreshToken != null) {
          return await refreshAccessToken(refreshToken);
        }
      }

      return token;
    } catch (e) {
      print('GetAccessToken error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await storage.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("profileImage");
      await prefs.remove("userRoles");
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
