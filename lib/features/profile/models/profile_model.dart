class ProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String avatar;
  final String? activeRoomCode;

  const ProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.avatar,
    this.activeRoomCode,
  });

  factory ProfileModel.fromMap(String uid, Map<dynamic, dynamic> map) {
    return ProfileModel(
      uid: uid,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? 'avatar_a.jpg',
      activeRoomCode: map['activeRoomCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'avatar': avatar,
      'activeRoomCode': activeRoomCode,
    };
  }

  ProfileModel copyWith({
    String? displayName,
    String? avatar,
    String? activeRoomCode,
  }) {
    return ProfileModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      avatar: avatar ?? this.avatar,
      activeRoomCode: activeRoomCode ?? this.activeRoomCode,
    );
  }
}
