import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/more_controller.dart';
import 'package:daxno_task/widgets/more_screen_buttons.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final MoreController controller = Get.put(MoreController());

    void showImagePickerOptions(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: greenColor,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  controller.image.value =
                      await controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  controller.image.value =
                      await controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Obx(
                  () => Stack(
                    children: [
                      controller.image.value != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  MemoryImage(controller.image.value!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png'),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => showImagePickerOptions(context),
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              boldText(text: "Profile Name"),
              const SizedBox(
                height: 20,
              ),

              //profile screens
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: accTitleList.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    height: 60,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: prussianBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          if (index >= 0 && index < controller.screens.length) {
                            // Navigate to the selected screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        controller.screens[index]));
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            normalText(
                                text: accTitleList[index],
                                color: whiteColor,
                                size: 16.0),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(rightangle),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                color: greyColor,
                thickness: 0.5,
              ),
              const SizedBox(
                height: 15,
              ),
              //GridView Buttons
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.0,
                    mainAxisExtent: 100),
                itemCount: accButtonTitleList.length,
                itemBuilder: (BuildContext context, int index) {
                  return moreScreenButtons(
                    icons: Image.asset(accButtonIconList[index]),
                    title: accButtonTitleList[index],
                    onPress: () {},
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
