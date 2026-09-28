import 'package:e201_toktik/domain/entities/video_post.dart';

class LocalVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;
  final int comments;
  final List<String> commentMessages;

  LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.commentMessages = const [],
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'] ?? 'No Name',
        videoUrl: json['videoUrl'],
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
        comments: json['comments'] ?? 0,
        commentMessages: List<String>.from(json['commentMessages'] ?? const []),
      );

  VideoPost toVideoPostEntity() => VideoPost(
    caption: name, 
    url: videoUrl,
    likes: likes,
    views: views,
    comments: comments,
    commentMessages: commentMessages,
  );
}
