class PartyRoom {
  final String roomCode;
  final String hostUid;
  final String? videoId;
  final bool isPlaying;
  final double currentSecond;
  final int createdAt;
  final Map<String, Map<String, dynamic>> participants;

  const PartyRoom({
    required this.roomCode,
    required this.hostUid,
    required this.videoId,
    required this.isPlaying,
    required this.currentSecond,
    required this.createdAt,
    required this.participants,
  });

  factory PartyRoom.fromMap(String roomCode, Map<dynamic, dynamic> map) {
    final rawParticipants = (map['participants'] as Map?) ?? {};

    return PartyRoom(
      roomCode: roomCode,
      hostUid: map['hostUid'] ?? '',
      videoId: map['videoId'],
      isPlaying: map['isPlaying'] ?? false,
      currentSecond: (map['currentSecond'] ?? 0).toDouble(),
      createdAt: map['createdAt'] ?? 0,
      participants: rawParticipants.map(
        (key, value) =>
            MapEntry(key.toString(), Map<String, dynamic>.from(value as Map)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostUid': hostUid,
      'videoId': videoId,
      'isPlaying': isPlaying,
      'currentSecond': currentSecond,
      'createdAt': createdAt,
      'participants': participants,
    };
  }
}
