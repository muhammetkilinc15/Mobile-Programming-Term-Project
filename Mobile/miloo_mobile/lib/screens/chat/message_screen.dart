import 'package:flutter/material.dart';
import 'package:miloo_mobile/services/message_service.dart';
import 'package:miloo_mobile/models/message.dart';

class MessageScreen extends StatefulWidget {
  final int toUserId;
  final String? toUserImage;
  final String? fullName;

  const MessageScreen({
    Key? key,
    required this.toUserId,
    this.toUserImage,
    this.fullName,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _messageService.initializeUserId();
      await _messageService.initializeSignalR((message) {
        setState(() {
          messages.add(message);
        });
        _scrollToBottom();
      });
      final fetchedMessages = await _messageService.fetchChats(widget.toUserId);
      setState(() {
        messages.addAll(fetchedMessages);
      });
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageService.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String messageText) async {
    try {
      await _messageService.sendMessage(
        toUserId: widget.toUserId,
        message: messageText,
      );
      _controller.clear();
      setState(() {
        messages.add(Message(
          id: 1,
          senderId: _messageService.userId,
          receiverId: widget.toUserId,
          messageText: messageText,
          sentOn: DateTime.now(),
          isRead: false,
        ));
      });
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.toUserImage!),
            ),
            const SizedBox(width: 10),
            Text(widget.fullName!),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'view_user') {
                // Kullanıcıyı görüntüleme ekranına yönlendirin
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserDetailScreen(userId: widget.toUserId),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'view_user',
                  child: Text('Kullanıcıyı Görüntüle'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.senderId == _messageService.userId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: message.senderId == _messageService.userId
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.messageText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kullanıcı detaylarını gösteren ekranı burada oluşturun
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Detayları'),
      ),
      body: Center(
        child: Text('Kullanıcı ID: $userId'),
      ),
    );
  }
}
