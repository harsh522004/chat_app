import 'package:chat_app/Widgets/message_bubbles.dart';
import 'package:chat_app/constant/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'image_message.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No Messages Found',
              style: TextStyle(color: materialColor[800]),
            ));
          }
          if (chatSnapshots.hasError) {
            return Center(
                child: Text(
              'Something Went Wrong....!',
              style: TextStyle(color: materialColor[800]),
            ));
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final messageType = chatMessage['messageType'];

                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;

                final currentMessageUserId = chatMessage['userId'];
                final nextUserMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;

                final nextUserIsSame =
                    nextUserMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  if (messageType == 'image') {
                    return ImageMessage.next(
                        imageUrl: chatMessage['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId);
                  } else {
                    return MessageBubble.next(
                        message: chatMessage['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId);
                  }
                } else {
                  if (messageType == 'image') {
                    return ImageMessage.first(
                        userImage: chatMessage['userImage'],
                        username: chatMessage['username'],
                        imageUrl: chatMessage['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId);
                  } else {
                    return MessageBubble.first(
                        userImage: chatMessage['userImage'],
                        username: chatMessage['username'],
                        message: chatMessage['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId);
                  }
                }
              });
        });
  }
}
