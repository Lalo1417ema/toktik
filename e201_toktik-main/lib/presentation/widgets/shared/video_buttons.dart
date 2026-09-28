import 'package:animate_do/animate_do.dart';
import 'package:e201_toktik/config/helpers/human_formats.dart';
import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

class VideoButtons extends StatefulWidget {
  final VideoPost video;
  final ValueChanged<String> onAddComment;

  const VideoButtons({
    super.key,
    required this.video,
    required this.onAddComment,
  });

  @override
  State<VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<VideoButtons> {
  late int likesCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likesCount = widget.video.likes;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likesCount++;
      } else {
        likesCount--;
      }
    });
  }

  Future<void> _showComments() async {
    final commentController = TextEditingController();
    final comments = List<String>.of(widget.video.commentMessages);
    var commentsCount = widget.video.comments;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF202020),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  Text(
                    'Comentarios ($commentsCount)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: comments.isEmpty
                        ? const Center(
                            child: Text(
                              'Aún no hay comentarios. ¡Sé el primero!',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: const Icon(
                                Icons.account_circle,
                                color: Colors.white70,
                              ),
                              title: Text(
                                comments[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _submitComment(
                            commentController,
                            comments,
                            () => commentsCount++,
                            setSheetState,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Escribe un comentario...',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _submitComment(
                          commentController,
                          comments,
                          () => commentsCount++,
                          setSheetState,
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    commentController.dispose();
  }

  void _submitComment(
    TextEditingController controller,
    List<String> comments,
    VoidCallback incrementCommentCount,
    StateSetter setSheetState,
  ) {
    final comment = controller.text.trim();
    if (comment.isEmpty) return;

    widget.onAddComment(comment);
    setSheetState(() {
      comments.add(comment);
      incrementCommentCount();
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomIconButton(
          value: likesCount,
          icon: Icons.favorite,
          iconColor: isLiked ? Colors.red : Colors.white,
          onPressed: _toggleLike,
        ),
        const SizedBox(height: 20),

        _CustomIconButton(
          value: widget.video.comments,
          icon: Icons.chat_bubble_outline,
          onPressed: _showComments,
        ),
        const SizedBox(height: 20),

        _CustomIconButton(
          value: widget.video.views,
          icon: Icons.remove_red_eye_outlined,
        ),
        const SizedBox(height: 20),

        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: const _CustomIconButton(
            value: 0,
            icon: Icons.play_circle_outline,
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.value,
    required this.icon,
    Color? iconColor,
    this.onPressed,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: 30),
        ),
        if (value > 0)
          Text(
            HumanFormats.humanReadableNumber(value.toDouble()),
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }
}