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

    ref
        .read(youtubeSyncControllerProvider)
        .listen(
          roomCode: widget.roomCode,
          onRemoteChanged: (videoId, isPlaying, position) async {
            if (videoId.isEmpty) return;

            if (currentVideoId != videoId) {
              await controller.loadVideoById(
                videoId: videoId,
                startSeconds: position,
              );

              currentVideoId = videoId;
            } else {
              await controller.seekTo(seconds: position, allowSeekAhead: true);
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

    await ref
        .read(youtubeSyncControllerProvider)
        .loadVideo(roomCode: widget.roomCode, videoId: id);
        currentVideoId = id;

    setState(() {
      loadingVideo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHost = ref.watch(isHostProvider(widget.roomCode));

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: controller),
        ),

        const SizedBox(height: 16),

        if (isHost)
          TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: "Paste YouTube URL",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: loadingVideo ? null : loadVideo,
                icon: const Icon(Icons.send),
              ),
            ),
          ),

        const SizedBox(height: 16),

        if (isHost)
          Wrap(
            spacing: 12,
            children: [
              FilledButton(
                onPressed: () async {
                  controller.playVideo();

                  final pos = await controller.currentTime;

                  ref
                      .read(youtubeSyncControllerProvider)
                      .play(roomCode: widget.roomCode, position: pos);
                },
                child: const Text("Play"),
              ),
              FilledButton(
                onPressed: () async {
                  controller.pauseVideo();

                  final pos = await controller.currentTime;

                  ref
                      .read(youtubeSyncControllerProvider)
                      .pause(roomCode: widget.roomCode, position: pos);
                },
                child: const Text("Pause"),
              ),
              FilledButton(
                onPressed: () async {
                  final pos = await controller.currentTime;

                  final newPosition = pos + 10;

                  await controller.seekTo(
                    seconds: newPosition,
                    allowSeekAhead: true,
                  );

                  ref
                      .read(youtubeSyncControllerProvider)
                      .seek(
                        roomCode: widget.roomCode,
                        position: newPosition,
                        isPlaying: true,
                      );
                },
                child: const Text("+10s"),
              ),
            ],
          ),
      ],
    );
  }
}
