class VideoPost {
  final String caption;
  final String url;
  final int likes;
  final int views;
  final int comments;
  final List<String> commentMessages;

  VideoPost({
    required this.caption,
    required this.url,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.commentMessages = const [],
  }) : assert(comments >= commentMessages.length);
}