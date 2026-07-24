class AppUser {
  final String uid;
  final String email;
  final String username;
  final String usernameLower;
  final String displayName;
  final String? photoUrl;
  final int createdAt;
  final String avatar;

  const AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.usernameLower,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.avatar,
  });

  factory AppUser.fromMap(Map<dynamic, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      usernameLower: map['usernameLower'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] ?? 0,
      avatar: map['avatar'] ?? 'Avatar A.jpg',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'usernameLower': usernameLower,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'avatar': avatar,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    String? usernameLower,
    String? displayName,
    String? photoUrl,
    String? avatar,
    bool? isOnline,
    int? createdAt,
    int? lastSeen,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      usernameLower: usernameLower ?? this.usernameLower,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      avatar: avatar ?? this.avatar,
    );
  }
}