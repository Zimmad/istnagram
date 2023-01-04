import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:istnagram/views/components/animations/error_animation_view.dart';
import 'package:istnagram/views/components/animations/loading_animation_view.dart';
import 'package:video_player/video_player.dart';

import '../../../state/posts/typedef/models/post.dart';

class PostVideoView extends StatelessWidget {
  const PostVideoView({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = VideoPlayerController.network(post.fileUrl);
    final isVideoPlayerReady = useState(false);
    useEffect(() {
      videoPlayerController.initialize().then((value) {
        isVideoPlayerReady.value = true;
        videoPlayerController.setLooping(true);
        videoPlayerController.play();
      });
      return videoPlayerController.dispose;
    }, [videoPlayerController]);
    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(videoPlayerController),
        );
      case false:
        return const LoadingAnimationView();
      default:
        return const ErrorAnimationView();
    }
  }
}
