import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';

class TokenManager {
  final _storage = const FlutterSecureStorage();

  Future<String> getAccessToken() async {
    try {
      String? token = await _storage.read(key: "accessToken");

      if (token == null) {
        throw Exception("No access token found");
      }

      if (JwtDecoder.isExpired(token)) {
        token = await _refreshToken();
      }

      return token;
    } catch (e) {
      throw Exception("Token error: $e");
    }
  }

  Future<String> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: "refreshToken");

      if (refreshToken == null) {
        throw Exception("No refresh token found");
      }

      final response = await http.post(
        Uri.parse("${baseUrl}auth/refresh-token"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "refreshToken": refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        await _storage.write(key: "accessToken", value: data["accessToken"]);
        await _storage.write(key: "refreshToken", value: data["refreshToken"]);
        return data["accessToken"];
      } else {
        throw Exception("Failed to refresh token");
      }
    } catch (e) {
      throw Exception("Token refresh failed: $e");
    }
  }
}
