import 'dart:io';

import 'package:chat_app/constant/Colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileImage extends StatefulWidget {
  const UserProfileImage({super.key,required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  File? _pickedImageFile;

  void userPickerImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        children: [
          GestureDetector(
            onTap: userPickerImage,
            child: CircleAvatar(

              radius: 35,
              backgroundColor: materialColor[800],
              foregroundImage:
                  _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
            ),
          ),

        ],
      ),
    );
  }
}
