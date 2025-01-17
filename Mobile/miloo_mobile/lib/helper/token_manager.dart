import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';

class TokenManager {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String> getAccessToken() async {
    final token = await storage.read(key: "accessToken");

    if (token != null && !JwtDecoder.isExpired(token)) {
      return token;
    }
    return await refreshAccessToken();
  }

  Future<String> refreshAccessToken() async {
    final refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) {
      throw Exception(
          "Refresh token bulunamadı. Kullanıcı yeniden giriş yapmalı.");
    }

    final response = await http.post(
      Uri.parse("${baseUrl}auth/refresh-token"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newAccessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];

      await storage.write(key: "accessToken", value: newAccessToken);
      await storage.write(key: "refreshToken", value: newRefreshToken);

      return newAccessToken;
    } else {
      throw Exception(
          "Token yenileme başarısız. Yeniden giriş yapmanız gerekiyor.");
    }
  }
}
