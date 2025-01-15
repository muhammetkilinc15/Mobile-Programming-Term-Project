class SendMessageModel {
  final int userId;
  final int toUserId;
  final String message;

  SendMessageModel({
    required this.userId,
    required this.toUserId,
    required this.message,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      userId: json['userId'],
      toUserId: json['toUserId'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'toUserId': toUserId,
      'message': message,
    };
  }
}
