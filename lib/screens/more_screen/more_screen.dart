import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/more_controller.dart';
import 'package:daxno_task/widgets/more_screen_buttons.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Center(
                child: Obx(
                  () => Stack(
                    children: [
                      controller.image.value != null
                          ? CircleAvatar(
                              radius: screenWidth * 0.18,
                              backgroundImage:
                                  MemoryImage(controller.image.value!),
                            )
                          : CircleAvatar(
                              radius: screenWidth * 0.18,
                              backgroundImage: const NetworkImage(
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

              SizedBox(
                height: screenHeight * 0.050,
              ),

              boldText(text: "Profile Name", textAlign: TextAlign.center),

              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: screenHeight * 0.03),
                child: const Divider(thickness: 1.0, color: greyColor),
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
                        gradient: LinearGradient(
                          colors: transColor,
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
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
                              size: 16.0,
                            ),
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

              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  bottom: screenHeight * 0.03,
                  top: screenHeight * 0.03,
                ),
                child: const Divider(thickness: 1.0, color: greyColor),
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
              ),
              const SizedBox(
                height: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
