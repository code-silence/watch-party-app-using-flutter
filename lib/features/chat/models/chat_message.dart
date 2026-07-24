class ChatMessage {
  final String id;
  final String senderUid;
  final String displayName;
  final String avatar;
  final String message;
  final int createdAt;

  const ChatMessage({
    required this.id,
    required this.senderUid,
    required this.displayName,
    required this.avatar,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(
    String id,
    Map<dynamic, dynamic> map,
  ) {
    return ChatMessage(
      id: id,
      senderUid: map['senderUid'] ?? '',
      displayName: map['displayName'] ?? '',
      avatar: map['avatar'] ?? '',
      message: map['message'] ?? '',
      createdAt: map['createdAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'displayName': displayName,
      'avatar': avatar,
      'message': message,
      'createdAt': createdAt,
    };
  }
}