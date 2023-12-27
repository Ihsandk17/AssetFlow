import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePictureScreen extends StatelessWidget {
  final String? imagePath;
  final String heroTag;

  const ProfilePictureScreen({
    Key? key,
    required this.imagePath,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < -10) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Hero(
              tag: heroTag,
              child: Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
