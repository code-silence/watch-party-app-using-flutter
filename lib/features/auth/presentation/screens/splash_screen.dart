import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/intro.mp4');

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
  await _controller.initialize();
  await _controller.setLooping(false);
  await _controller.setVolume(1.0);

  setState(() {});

  _controller.addListener(() {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    if (duration != Duration.zero &&
        position >= duration &&
        mounted) {
      _controller.removeListener(() {});

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  });

  await _controller.play();
}

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }
}
