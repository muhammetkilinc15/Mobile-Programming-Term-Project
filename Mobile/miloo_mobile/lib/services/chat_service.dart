import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:http/http.dart' as http;
import 'package:miloo_mobile/helper/token_manager.dart';
import 'package:miloo_mobile/models/message.dart';
import 'package:miloo_mobile/models/send_message_model.dart';
import 'package:miloo_mobile/models/user_message.dart';

class ChatService {
  String url = "${baseUrl}Chat";
  final TokenManager _tokenManager = TokenManager();

// Mesajlaştıgın kişileri getirir
  Future<List<UserMessage>> getUsers() async {
    final token = await _tokenManager.getAccessToken();
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);
    final response = await http.get(Uri.parse("$url/users/$userId"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

// Mesajları getirir
  Future<List<Message>> getMessages(int toUserId) async {
    final token = await _tokenManager.getAccessToken();
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);
    final response = await http.get(
      Uri.parse("$url/chats?userId=$userId&toUserId=$toUserId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

// Mesaj gönderir
  Future<void> sendMessage(SendMessageModel model) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/SendMessage'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      print("Message sent");
    } else {
      throw Exception('Failed to send message');
    }
  }
}
