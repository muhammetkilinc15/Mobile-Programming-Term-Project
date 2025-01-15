import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/chat/message_screen.dart';
import 'package:miloo_mobile/services/chat_service.dart';
import 'package:miloo_mobile/models/user_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<UserMessage>> _chatUsersFuture;

  @override
  void initState() {
    super.initState();
    _chatUsersFuture = _fetchChatUsers();
  }

  Future<List<UserMessage>> _fetchChatUsers() async {
    try {
      return await ChatService.getUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load chat users: $e')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: FutureBuilder<List<UserMessage>>(
        future: _chatUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chat users found.'));
          } else {
            final chatUsers = snapshot.data!;
            return ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return ListTile(
                  title: Text(user.fullName),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePhoto),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          toUserId: user.userId,
                          fullName: user.fullName,
                          toUserImage: user.profilePhoto,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
