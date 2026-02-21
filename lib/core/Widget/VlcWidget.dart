import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VlcVideoWidget extends StatelessWidget {
  final VlcPlayerController controller;

  const VlcVideoWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VlcPlayer(
      controller: controller,
      aspectRatio: 16 / 9,
      placeholder: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
