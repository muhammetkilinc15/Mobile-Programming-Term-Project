import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:http/http.dart' as http;
import 'package:miloo_mobile/models/message.dart';
import 'package:miloo_mobile/models/send_message_model.dart';
import 'package:miloo_mobile/models/user_message.dart';

class ChatService {
  static String url = "${baseUrl}Chat";

  // Chat/users/1
  static Future<List<UserMessage>> getUsers() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);
    final response = await http.get(Uri.parse("$url/users/$userId"));
    print("hata : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // chats?userId=1&toUserId=2
  static Future<List<Message>> getMessages(int toUserId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);
    final response = await http
        .get(Uri.parse("$url/chats?userId=$userId&toUserId=$toUserId"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<void> sendMessage(SendMessageModel model) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      print("Message sent");
    } else {
      throw Exception('Failed to send message');
    }
  }
}
