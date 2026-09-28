import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/infrastructure/models/local_video_model.dart';
import 'package:e201_toktik/shared/data/local_video_post.dart';
import 'package:flutter/material.dart';

class DiscoverProvider extends ChangeNotifier {

  bool initialLoading = true;

  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    await Future.delayed(Duration(seconds: 2));

    final List<VideoPost> newVideos = videoPosts
        .map((video) => LocalVideoModel.fromJson(video).toVideoPostEntity())
        .toList();
    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }

  void recordVideoView(int index) {
    final video = videos[index];
    videos[index] = VideoPost(
      caption: video.caption,
      url: video.url,
      likes: video.likes,
      views: video.views + 1,
      comments: video.comments,
      commentMessages: video.commentMessages,
    );
    notifyListeners();
  }

  void addComment(int index, String message) {
    final comment = message.trim();
    if (comment.isEmpty) return;

    final video = videos[index];
    videos[index] = VideoPost(
      caption: video.caption,
      url: video.url,
      likes: video.likes,
      views: video.views,
      comments: video.comments + 1,
      commentMessages: [...video.commentMessages, comment],
    );
    notifyListeners();
  }
}
