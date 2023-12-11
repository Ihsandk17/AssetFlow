import 'dart:typed_data';

import 'package:daxno_task/screens/more_screen/screens/accounts.dart';
import 'package:daxno_task/screens/more_screen/screens/backup.dart';
import 'package:daxno_task/screens/more_screen/screens/profile.dart';
import 'package:daxno_task/screens/more_screen/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MoreController extends GetxController {
  //acc screen list
  List<Widget> screens = [
    const Profile(),
    const Accounts(),
    const Setting(),
    const Backup(),
  ];

  //Image picker logic
  final Rx<Uint8List?> image = Rx<Uint8List?>(null);

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }

    // ignore: avoid_print
    print('No images selected');
    return null;
  }
}
