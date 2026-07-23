class VideoStateModel {
  final String videoId;
  final bool isPlaying;
  final double position;
  final int updatedAt;

  const VideoStateModel({
    required this.videoId,
    required this.isPlaying,
    required this.position,
    required this.updatedAt,
  });

  factory VideoStateModel.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return VideoStateModel(
      videoId: map['videoId'] ?? '',
      isPlaying: map['isPlaying'] ?? false,
      position: (map['position'] ?? 0).toDouble(),
      updatedAt: map['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'isPlaying': isPlaying,
      'position': position,
      'updatedAt': updatedAt,
    };
  }
}