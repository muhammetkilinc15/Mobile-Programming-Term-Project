class UserMessage {
  final int userId;
  final String fullName;
  final String profilePhoto;
  final LastMessage lastMessage;

  UserMessage({
    required this.userId,
    required this.fullName,
    required this.profilePhoto,
    required this.lastMessage,
  });

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      userId: json['userId'],
      fullName: json['fullName'],
      profilePhoto: json['profilePhoto'],
      lastMessage: LastMessage.fromJson(json['lastMessage']),
    );
  }
}

class LastMessage {
  final int messageId;
  final String message;
  final String sendDate;
  final bool isRead;

  LastMessage({
    required this.messageId,
    required this.message,
    required this.sendDate,
    required this.isRead,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      messageId: json['messageId'],
      message: json['message'],
      sendDate: json['sendDate'],
      isRead: json['isRead'],
    );
  }
}
