import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (type == MessageEnum.text) {
      widget = Text(
        message,
        style: const TextStyle(fontSize: 16, color: textColor),
      );
    } else if (type == MessageEnum.video) {
      widget = VideoPlayerItem(videoUrl: message);
    } else if (type == MessageEnum.image) {
      widget = CachedNetworkImage(imageUrl: message);
    }
    else if (type == MessageEnum.gif) {
      widget = CachedNetworkImage(imageUrl: message);
    } else {
      throw ArgumentError('Invalid message type');
    }

    return widget;
  }
}
