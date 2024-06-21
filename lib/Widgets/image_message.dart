import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.imageUrl,
    required this.isMe,
  }) : isFirstInSequence = true;

  const ImageMessage.next({
    super.key,
    required this.imageUrl,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final String imageUrl;
  final bool isMe;
  final bool isFirstInSequence;
  final String? username;
  final String? userImage;

  @override
  Widget build(BuildContext context) {
    // Customize this widget to display image messages with the desired format.
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            // Align user image to the right, if the message is from me.
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userImage!,
              ),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 18),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(imageUrl,fit: BoxFit.fill,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
