class Message {
  int senderId;
  int receiverId;
  String messageText;
  DateTime sentOn;
  bool isRead;
  int id;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.sentOn,
    required this.isRead,
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      sentOn: DateTime.parse(json['sentOn']),
      isRead: json['isRead'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'sentOn': sentOn.toIso8601String(),
      'isRead': isRead,
      'id': id,
    };
  }
}


// [
//   {
//     "senderId": 2,
//     "receiverId": 1,
//     "messageText": "adamsın",
//     "sentOn": "2023-02-01T00:00:00",
//     "isRead": true,
//     "id": 4
//   },
//   {
//     "senderId": 1,
//     "receiverId": 2,
//     "messageText": "Naber Kral",
//     "sentOn": "2023-12-10T00:00:00",
//     "isRead": true,
//     "id": 1
//   },
//   {
//     "senderId": 2,
//     "receiverId": 1,
//     "messageText": "ne diyon abee",
//     "sentOn": "2025-01-15T00:00:00",
//     "isRead": true,
//     "id": 5
//   }
// ]