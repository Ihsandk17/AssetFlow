import 'package:daxno_task/utils/database_helper.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  RxBool isObscure = true.obs;
  final Rx<String?> profilePhoto = Rx<String?>(null);

  updateObscure() {
    isObscure.value = !isObscure.value;
  }

  updatePhoto() async {
    profilePhoto.value = await DatabaseHelper().getPhoto();
  }
}
