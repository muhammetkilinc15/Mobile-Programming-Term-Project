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
    print(registerModel.toJson());
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

  Future<bool> verifyEmail(
      {required String email, required String code}) async {
    print(code);
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

  Future<bool> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse("${url}login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        "usernameOrEmail": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);

      await storage.write(key: "accessToken", value: body["accessToken"]);
      await storage.write(key: "refreshToken", value: body["refreshToken"]);
      await storage.write(key: "tokenExpiration", value: body["expiration"]);
      final prefs = await SharedPreferences.getInstance();
      String profileImage =
          JwtDecoder.decode(body["accessToken"])["profileImage"];
      prefs.setString("profileImage", profileImage);

      print(prefs.get("profileImage"));

      return true;
    }
    return false;
  }

  // AccessToken'ı alma (eğer yoksa refresh token ile yenile)
  Future<String?> getAccessToken() async {
    final token = await storage.read(key: "accessToken");

    if (token != null) {
      return token;
    } else {
      // Eğer token geçerli değilse refreshToken kullanarak yenile
      final refreshToken = await storage.read(key: "refreshToken");
      if (refreshToken != null) {
        return await refreshAccessToken(refreshToken);
      }
    }
    return null;
  }

  // RefreshToken kullanarak accessToken yenileme
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

  // Çıkış işlemi
  Future<void> logout() async {
    // Tüm tokenları temizle
    await storage.deleteAll();
  }
}
