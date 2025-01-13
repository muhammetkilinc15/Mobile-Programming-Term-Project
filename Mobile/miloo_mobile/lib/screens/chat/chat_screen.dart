import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hello!', 'isMe': true, 'time': DateTime.now()},
    {'text': 'Hi there!', 'isMe': false, 'time': DateTime.now()},
    {'text': 'How are you?', 'isMe': true, 'time': DateTime.now()},
    {'text': 'I am good, thanks!', 'isMe': false, 'time': DateTime.now()},
    {'text': 'What about you?', 'isMe': false, 'time': DateTime.now()},
    {'text': 'I am fine too.', 'isMe': true, 'time': DateTime.now()},
  ];

  final List<Map<String, dynamic>> chats = [
    {'name': 'User 1', 'lastMessage': 'Hello!', 'time': '10:00 AM'},
    {'name': 'User 2', 'lastMessage': 'Hi there!', 'time': '10:05 AM'},
    {'name': 'User 3', 'lastMessage': 'How are you?', 'time': '10:10 AM'},
    {'name': 'User 4', 'lastMessage': 'I am good, thanks!', 'time': '10:15 AM'},
  ];

  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(
            {'text': _controller.text, 'isMe': true, 'time': DateTime.now()});
        _controller.clear();
      });
      _scrollToBottom();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        messages.add(
            {'image': pickedFile.path, 'isMe': true, 'time': DateTime.now()});
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            title: Text(chat['name']),
            subtitle: Text(chat['lastMessage']),
            trailing: Text(chat['time']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    name: chat['name'],
                    messages: messages,
                    onSendMessage: _sendMessage,
                    onPickImage: _pickImage,
                    controller: _controller,
                    scrollController: _scrollController,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final List<Map<String, dynamic>> messages;
  final VoidCallback onSendMessage;
  final Future<void> Function(ImageSource) onPickImage;
  final TextEditingController controller;
  final ScrollController scrollController;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.messages,
    required this.onSendMessage,
    required this.onPickImage,
    required this.controller,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: message['isMe'] ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: message.containsKey('image')
                        ? Image.file(File(message['image']))
                        : Text(
                            message['text'],
                            style: TextStyle(
                                color: message['isMe']
                                    ? Colors.white
                                    : Colors.black),
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
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheet(
                        onClosing: () {},
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text('Camera'),
                              onTap: () {
                                Navigator.pop(context);
                                onPickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                onPickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
