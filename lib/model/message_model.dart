class MessageModel {
  late String receiverId;
  late String senderId;
  late String content;
  late String dateTime;

  MessageModel({
    required this.receiverId,
    required this.senderId,
    required this.content,
    required this.dateTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      receiverId: json["receiverId"],
      senderId: json["senderId"],
      content: json["content"],
      dateTime: json["dateTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "receiverId": receiverId,
      "senderId": senderId,
      "content": content,
      "dateTime": dateTime,
    };
  }
}
