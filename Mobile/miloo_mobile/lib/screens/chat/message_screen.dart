import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miloo_mobile/services/message_service.dart';
import 'package:miloo_mobile/models/message.dart';
import 'package:miloo_mobile/size_config.dart';

class MessageScreen extends StatefulWidget {
  final int toUserId;
  final String? toUserImage;
  final String? fullName;
  static const routeName = '/message';

  const MessageScreen({
    super.key,
    required this.toUserId,
    this.toUserImage,
    this.fullName,
  });

  @override
  // ignore: library_private_types_in_public_api
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

  @override
  void dispose() {
    _messageService.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
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
      final fetchedMessages =
          await _messageService.fetchChats(widget.toUserId, "mamikilinc15");
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

  Future<void> _sendMessage(String messageText) async {
    try {
      await _messageService.sendMessage(
        toUserId: widget.toUserId,
        message: messageText,
      );
      _controller.clear();
      setState(() {
        messages.add(Message(
          id: -1,
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
        duration: const Duration(milliseconds: 200),
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
        actions: const [
          Icon(
            Icons.more_vert_rounded,
          )
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
                return MessageWidget(
                  messageText: message.messageText,
                  sentOn: message.sentOn,
                  senderId: message.senderId,
                  currentUserId:
                      _messageService.userId, // Kendi kullanıcı ID'si
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
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

class MessageWidget extends StatelessWidget {
  final String messageText;
  final DateTime sentOn;
  final int senderId;
  final int currentUserId;

  const MessageWidget({
    super.key,
    required this.messageText,
    required this.sentOn,
    required this.senderId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(sentOn);

    return Align(
      alignment: senderId == currentUserId
          ? Alignment.centerRight // Kendi mesajlarımız sağa yaslanacak
          : Alignment
              .centerLeft, // Diğer kullanıcıların mesajları sola yaslanacak
      child: Container(
        constraints: BoxConstraints(maxWidth: getProportionateScreenWidth(250)),
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        margin: EdgeInsets.all(getProportionateScreenWidth(5)),
        decoration: BoxDecoration(
          color: senderId == currentUserId
              ? Colors.blue // Kendi mesajlarımız mavi
              : Colors.grey, // Diğer kullanıcıların mesajları gri
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mesaj metni
            Text(
              messageText,
              style: const TextStyle(color: Colors.white),
              softWrap: true, // Metnin birden fazla satıra sığmasını sağlar
              overflow: TextOverflow.visible, // Taşan metni gösterir
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              formattedTime,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
