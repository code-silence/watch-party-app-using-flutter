import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../core/utils/youtube_utils.dart';
import '../../../party/providers/host_provider.dart';
import '../../providers/youtube_sync_controller.dart';

class SyncedYoutubePlayer extends ConsumerStatefulWidget {
  const SyncedYoutubePlayer({super.key, required this.roomCode});

  final String roomCode;

  @override
  ConsumerState<SyncedYoutubePlayer> createState() =>
      _SyncedYoutubePlayerState();
}

class _SyncedYoutubePlayerState extends ConsumerState<SyncedYoutubePlayer> {
  late YoutubePlayerController controller;

  final urlController = TextEditingController();

  bool playerReady = false;

  bool loadingVideo = false;

  String? currentVideoId;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    controller.listen((value) async {
      if (value.playerState == PlayerState.ended) {
        await ref
            .read(youtubeSyncControllerProvider)
            .pause(roomCode: widget.roomCode, position: 0);

        currentVideoId = null;
      }
    });

    ref
        .read(youtubeSyncControllerProvider)
        .listen(
          roomCode: widget.roomCode,
          onRemoteChanged: (videoId, isPlaying, position, updatedAt) async {
            if (videoId.isEmpty) return;
            double startPosition = position;

            if (isPlaying && updatedAt > 0) {
              final elapsed =
                  (DateTime.now().millisecondsSinceEpoch - updatedAt) / 1000;

              startPosition += elapsed;
            }

            if (currentVideoId != videoId) {
              await controller.loadVideoById(
                videoId: videoId,
                startSeconds: startPosition,
              );

              currentVideoId = videoId;
            } else {
              await controller.seekTo(
                seconds: startPosition,
                allowSeekAhead: true,
              );
            }

            if (isPlaying) {
              controller.playVideo();
            } else {
              controller.pauseVideo();
            }
          },
        );
  }

  @override
  void dispose() {
    urlController.dispose();

    controller.close();

    ref.read(youtubeSyncControllerProvider).dispose();

    super.dispose();
  }

  Future<void> loadVideo() async {
    final id = YoutubeUtils.extractVideoId(urlController.text);

    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid YouTube URL")));

      return;
    }

    setState(() {
      loadingVideo = true;
    });

    await controller.loadVideoById(videoId: id, startSeconds: 0);

    currentVideoId = id;

    await ref
        .read(youtubeSyncControllerProvider)
        .loadVideo(roomCode: widget.roomCode, videoId: id);
    setState(() {
      loadingVideo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHost = ref.watch(isHostProvider(widget.roomCode));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: controller),
        ),
        if (isHost) ...[
          const SizedBox(height: 12),
          TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Paste YouTube URL",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              IconButton.filled(
                tooltip: 'Play',
                onPressed: () async {
                  final id = YoutubeUtils.extractVideoId(urlController.text);

                  if (id != null && id != currentVideoId) {
                    await loadVideo();
                  }

                  controller.playVideo();

                  final pos = await controller.currentTime;

                  await ref
                      .read(youtubeSyncControllerProvider)
                      .play(roomCode: widget.roomCode, position: pos);
                },
                icon: const Icon(Icons.play_arrow),
              ),
              IconButton.filled(
                onPressed: () async {
                  controller.pauseVideo();

                  final pos = await controller.currentTime;

                  ref
                      .read(youtubeSyncControllerProvider)
                      .pause(roomCode: widget.roomCode, position: pos);
                },
                icon: const Icon(Icons.pause),
              ),
              IconButton.filled(
                onPressed: () async {
                  final pos = await controller.currentTime;
                  final state = await controller.playerState;

                  final newPosition = pos + 10;

                  await controller.seekTo(
                    seconds: newPosition,
                    allowSeekAhead: true,
                  );

                  await ref
                      .read(youtubeSyncControllerProvider)
                      .seek(
                        roomCode: widget.roomCode,
                        position: newPosition,
                        isPlaying: state == PlayerState.playing,
                      );
                },
                icon: const Icon(Icons.forward_10),
              ),
              IconButton.filled(
                onPressed: () async {
                  currentVideoId = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refresh requested')),
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton.filled(
                onPressed: () async {
                  final pos = await controller.currentTime;
                  final state = await controller.playerState;

                  final newPosition = (pos - 10)
                      .clamp(0.0, double.infinity)
                      .toDouble();

                  await controller.seekTo(
                    seconds: newPosition,
                    allowSeekAhead: true,
                  );

                  await ref
                      .read(youtubeSyncControllerProvider)
                      .seek(
                        roomCode: widget.roomCode,
                        position: newPosition,
                        isPlaying: state == PlayerState.playing,
                      );
                },
                icon: const Icon(Icons.replay_10),
              ),
            ],
          ),
        ],
      ],
    );
  }
}