class YoutubeUtils {
  const YoutubeUtils._();

  static String? extractVideoId(String input) {
    final text = input.trim();

    final patterns = [
      RegExp(r'youtu\.be\/([A-Za-z0-9_-]{11})'),
      RegExp(r'v=([A-Za-z0-9_-]{11})'),
      RegExp(r'embed\/([A-Za-z0-9_-]{11})'),
      RegExp(r'shorts\/([A-Za-z0-9_-]{11})'),
      RegExp(r'^([A-Za-z0-9_-]{11})$'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);

      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }
}