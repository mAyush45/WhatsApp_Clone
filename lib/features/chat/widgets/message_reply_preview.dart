import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';

import '../../../common/provider/message_reply_provider.dart';

class MessageReplyPreview extends ConsumerWidget {
  final String senderName;
  const MessageReplyPreview({required this.senderName, Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                
                Expanded(
                  child: Text(
                    messageReply!.isMe ? 'Me' : senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    CupertinoIcons.clear_circled_solid,
                    size: 20,
                    color: tabColor,
                  ),
                  onTap: () => cancelReply(ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DisplayTextImageGIF(
            message: messageReply.message,
            type: messageReply.messageEnum,
          ),
        ],
      ),
    );
  }
}
