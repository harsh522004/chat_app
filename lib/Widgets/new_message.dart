import 'package:chat_app/constant/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  bool _isTextFieldEmpty = true;
  File? _imageFile;

  void _updateTextFieldEmptyStatus() {
    setState(() {
      _isTextFieldEmpty = _messageController.text.trim().isEmpty;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty && _imageFile == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection('User').doc(user.uid).get();

    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('User_Images')
          .child('${user.uid}.jpg');

      try {
        await storageRef.putFile(_imageFile!);

        final imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance.collection('chat').add({
          'messageType': 'image',
          'text': imageUrl,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData.data()!['username'],
          'userImage': userData.data()!['imageUrl'],
        });

        // Clear the image file.
        setState(() {
          _imageFile = null;
        });
      } catch (error) {
        print("Error uploading image: $error");
        // Handle the error here, e.g., show a toast or error message.
      }
    }

    if (enteredMessage.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection('chat').add({
        'messageType': 'text',
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['imageUrl'],
      });
    }

    // Clear the message controller.
    _messageController.clear();
  }

  /*void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    //send to firebase

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection('User').doc(user.uid).get();

    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('User_Images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_imageFile!);

      final imageUrl = storageRef.getDownloadURL();
      FirebaseFirestore.instance.collection('chat').add({
        'messageType': 'image',
        'text': imageUrl,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['imageUrl'],
      });
    }

    if (enteredMessage.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection('chat').add({
        'messageType': 'text',
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['imageUrl'],
      });
    }
    _messageController.clear();
    setState(() {
      _imageFile = null;
    });
  }*/

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50, // You can adjust image quality as needed.
      maxWidth: 150, // You can adjust the maximum width.
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _imageFile = File(pickedImage.path);
    });

    _submitMessage();

    // Clear the text message field.
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10, bottom: 24),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: materialColor[200], // Background color
          borderRadius: BorderRadius.circular(24.0), // Rounded border
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 9,
            ),
            Expanded(
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                controller: _messageController,
                onChanged: (_) {
                  _updateTextFieldEmptyStatus();
                },
                decoration: const InputDecoration(
                  hintText: 'type your message.....',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: materialColor[800]),
              ),
            ),
            Visibility(
              visible: !_isTextFieldEmpty && _messageController.text.isNotEmpty,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: materialColor[600],
                ),
                child: IconButton(
                  onPressed: _submitMessage,
                  icon: const Icon(Icons.send),
                  color: materialColor[100],
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
            ),
            Visibility(
              visible: _isTextFieldEmpty || _messageController.text.isEmpty,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: materialColor[600],
                ),
                child: IconButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.camera_alt),
                  color: materialColor[100],
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
