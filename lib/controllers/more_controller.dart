// ignore_for_file: avoid_print

import 'package:daxno_task/screens/more_screen/screens/accounts.dart';
import 'package:daxno_task/screens/more_screen/screens/backup.dart';
import 'package:daxno_task/screens/more_screen/screens/edit_profile.dart';
import 'package:daxno_task/screens/more_screen/screens/setting.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MoreController extends GetxController {
  //acc screen list
  List<Widget> screens = [
    const EditProfile(),
    const Accounts(),
    const Setting(),
    const Backup(),
  ];

  //Image picker logic
  final Rx<String?> image = Rx<String?>(null);

  updatePhoto() async {
    image.value = await DatabaseHelper().getPhoto();
  }

  Future<String?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      String profilePicture = file.path;

      // Call method to save profile photo
      await saveProfilePicture(profilePicture);
      return profilePicture;
    }

    // Ignore: avoid_print
    print('No images selected');
    return null;
  }

  Future<void> saveProfilePicture(String imagePath) async {
    try {
      // Get current picture
      String? currentPicture = await DatabaseHelper().getPhoto();
      if (currentPicture != null) {
        // If a picture exists, update it
        await DatabaseHelper().updatePhoto(imagePath);
      } else {
        // If no picture exists, insert a new one
        await DatabaseHelper().insertPhoto(imagePath);
      }

      // Update the image value in the controller
      image.value = imagePath;
    } catch (e) {
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Error saving profile picture: $e');
    }
  }
}
