class YoutubeSyncState {
  final bool ignoreNextPlayerEvent;

  const YoutubeSyncState({
    this.ignoreNextPlayerEvent = false,
  });

  YoutubeSyncState copyWith({
    bool? ignoreNextPlayerEvent,
  }) {
    return YoutubeSyncState(
      ignoreNextPlayerEvent:
          ignoreNextPlayerEvent ?? this.ignoreNextPlayerEvent,
    );
  }
}