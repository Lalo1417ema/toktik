import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:e201_toktik/presentation/widgets/video/fullscreen_player.dart';
import 'package:flutter/material.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;
  final ValueChanged<int> onVideoViewed;
  final void Function(int index, String comment) onCommentAdded;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.onVideoViewed,
    required this.onCommentAdded,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.videos.isNotEmpty) {
        widget.onVideoViewed(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: (index) {
        setState(() => currentIndex = index);
        widget.onVideoViewed(index);
      },
      itemBuilder: (context, index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            SizedBox.expand(
              child: FullscreenPlayer(
                videoUrl: videoPost.url,
                caption: videoPost.caption,
                autoPlay: index == currentIndex,
              )
            ),

            Positioned(
              bottom: 40,
              right: 20,
              child: VideoButtons(
                video: videoPost,
                onAddComment: (comment) =>
                    widget.onCommentAdded(index, comment),
              )
            )
          ],
        );
      },
    );
  }
}
