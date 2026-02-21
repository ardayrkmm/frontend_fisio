import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Jika controller belum siap (antisipasi race condition)
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),

        // Optional: Play / Pause overlay
        GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: Icon(
              controller.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 64,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
