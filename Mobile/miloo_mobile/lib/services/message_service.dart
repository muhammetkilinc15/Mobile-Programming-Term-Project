import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/helper/token_manager.dart';
import 'package:miloo_mobile/models/send_message_model.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/message.dart';

class MessageService {
  static String url = "${baseUrl}Chat";
  late HubConnection _hubConnection;
  late int userId;
  final TokenManager _tokenManager = TokenManager();

  Future<void> initializeUserId() async {
    final token = await _tokenManager.getAccessToken();
    userId = int.parse(JwtDecoder.decode(token)["userId"]);
  }

  Future<void> initializeSignalR(Function(Message) onMessageReceived) async {
    _hubConnection =
        HubConnectionBuilder().withUrl('http://10.0.2.2:5105/ChatHub').build();
    await _hubConnection.start()?.then((_) async {
      print('Connection started');
      await _hubConnection.invoke('Connect', args: [userId]);
    });

    _hubConnection.on('Messages', (message) {
      onMessageReceived(Message.fromJson(message![0] as Map<String, dynamic>));
    });
  }

  Future<List<Message>> fetchChats(int toUserId, String? username) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.get(
        Uri.parse('$url/chats?userId=$userId&toUserId=$toUserId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<void> sendMessage({
    required int toUserId,
    required String message,
  }) async {
    final source = json.encode(SendMessageModel(
      userId: userId,
      toUserId: toUserId,
      message: message,
    ).toJson());

    final token = await _tokenManager.getAccessToken();

    final response = await http.post(
      Uri.parse('$url/SendMessage'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: source,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  void dispose() {
    _hubConnection.stop();
  }
}
