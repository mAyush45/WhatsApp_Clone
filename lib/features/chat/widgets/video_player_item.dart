import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
        videoPlayerController.addListener(videoPlayerListener);
      });
  }

  void videoPlayerListener() {
    if (videoPlayerController.value.isPlaying &&
        videoPlayerController.value.duration ==
            videoPlayerController.value.position) {
      // Video has completed playing
      videoPlayerController.seekTo(Duration.zero);
      videoPlayerController.pause();
    }

    setState(() {
      isPlay = videoPlayerController.value.isPlaying;
    });
  }


  @override
  void dispose() {
    super.dispose();
    videoPlayerController.removeListener(videoPlayerListener);
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isPlay = !isPlay;
                });

                if (isPlay) {
                  videoPlayerController.play();
                } else {
                  videoPlayerController.pause();
                }
              },

              icon: Icon(
                isPlay ? Icons.pause_circle : Icons.play_circle, color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
