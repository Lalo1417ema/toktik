import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final bool autoPlay;

  const FullscreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    required this.autoPlay,
  });

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  late VideoPlayerController controller;
  late final Future<void> _initializeVideo;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.videoUrl)
      ..setVolume(0)
      ..setLooping(true);
    _initializeVideo = controller.initialize().then((_) {
      if (mounted && widget.autoPlay) {
        controller.play();
      }
      if (mounted) {
        setState(() {});
      }
    });
    controller.addListener(_handlePlaybackChange);
  }

  @override
  void didUpdateWidget(covariant FullscreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay &&
        controller.value.isInitialized) {
      if (widget.autoPlay) {
        controller.play();
      } else {
        controller.pause();
      }
    }
  }

  void _togglePlayback() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _handlePlaybackChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_handlePlaybackChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideo,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Colors.black),
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (_) => _togglePlayback(),
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            if (!controller.value.isPlaying)
              const IgnorePointer(
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white70,
                    size: 72,
                  ),
                ),
              ),
            Positioned(
              bottom: 50,
              left: 20,
              child: IgnorePointer(
                child: _VideoCaption(caption: widget.caption),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(caption, maxLines: 2, style: titleStyle),
    );
  }
}
