import 'dart:io';

import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/widgets/rounded_text_field.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/more_controller.dart';
import '../../../utils/database_helper.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final MoreController controller = Get.put(MoreController());

    showBottomSheet(
        {title1, icon1, onTap1, title2, onTap2, icon2, title3, icon3, onTap3}) {
      showModalBottomSheet(
        backgroundColor: greenColor,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(leading: icon1, title: Text(title1!), onTap: onTap1),
              ListTile(leading: icon2, title: Text(title2!), onTap: onTap2),
              ListTile(leading: icon3, title: Text(title3!), onTap: onTap3),
            ],
          );
        },
      );
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController pinController = TextEditingController();

    void updateProfileData() async {
      //If you have fetched the data from the database, you can use the following code instead:
      String? existingPin = await DatabaseHelper().getPinCode();
      String? existingProfileName = await DatabaseHelper().getProfileName();
      pinController.text = existingPin ?? '';
      nameController.text = existingProfileName ?? '';
    }

// Call the method to fetch existing data when the screen is loaded
    updateProfileData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkPrussianBlue,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Obx(() {
                  controller.updatePhoto();
                  return CircleAvatar(
                    radius: screenWidth * 0.18,
                    backgroundImage: controller.image.value != null
                        ? FileImage(File(controller.image.value!))
                            as ImageProvider<Object>?
                        : const NetworkImage(
                            'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png'),
                  );
                }),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      showBottomSheet(
                          title1: 'Gallery',
                          icon1: const Icon(Icons.photo_library),
                          onTap1: () async {
                            Navigator.pop(context);
                            controller.image.value =
                                await controller.pickImage(ImageSource.gallery);
                          },
                          icon2: const Icon(Icons.photo_camera),
                          title2: 'Camera',
                          onTap2: () async {
                            Navigator.pop(context);
                            controller.image.value =
                                await controller.pickImage(ImageSource.camera);
                          },
                          icon3: const Icon(Icons.delete),
                          title3: 'Remove Photo',
                          onTap3: () async {
                            await DatabaseHelper().deletePhoto();
                            Get.back();
                          });
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: whiteColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(screenWidth * 0.04),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: transColor,
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: const Offset(0, 5), // Offset
                          )
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.03,
                          ),
                          child: roundedTextField(
                            controller: nameController,
                            hintText: profileName,
                            labelText: "Name",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.04,
                              bottom: screenHeight * 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.06),
                                child: normalText(
                                    text: 'Set 4 digit pin.',
                                    color: whiteColor),
                              ),
                              roundedTextField(
                                controller: pinController,
                                hintText: "i.e: 1234",
                                labelText: pinCode,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.12,
                  bottom: screenHeight * 0.03,
                  child: SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 109, 199),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.12,
                  bottom: screenHeight * 0.03,
                  child: SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 109, 199),
                      ),
                      onPressed: () async {
                        String pin = pinController.text;
                        String profileName = nameController.text;

                        if (pin.length == 4) {
                          await DatabaseHelper().setPinPName(pin, profileName);
                          pinController.clear();
                          nameController.clear();
                          Get.back();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shadowColor: blackColor,
                              backgroundColor: greenColor,
                              title: const Text('Invalid Pin Code'),
                              content: normalText(
                                  text: 'Do you want to set only profile Name?',
                                  color: Colors.red),
                              actions: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.07,
                                      right: screenWidth * 0.07),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.2,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 3, 216, 110),
                                              shadowColor: blackColor,
                                              elevation: 1),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: normalText(
                                              text: 'No', color: whiteColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.2,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 3, 216, 110),
                                                shadowColor: blackColor,
                                                elevation: 1),
                                            onPressed: () async {
                                              await DatabaseHelper()
                                                  .setProfileName(
                                                      pin, profileName);
                                              pinController.clear();
                                              nameController.clear();
                                              Get.back();
                                              Get.back();
                                            },
                                            child: normalText(
                                                text: 'Yes',
                                                color: whiteColor)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  normalText(text: 'Do you want to delete pin code?'),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shadowColor: blackColor,
                            backgroundColor: greenColor,
                            title: const Text('Delete Pin Code!'),
                            content: normalText(
                                text: 'Are you sure to delete pin code?',
                                color: Colors.red),
                            actions: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.07,
                                    right: screenWidth * 0.07),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 3, 216, 110),
                                            shadowColor: blackColor,
                                            elevation: 1),
                                        onPressed: () => Navigator.pop(context),
                                        child: normalText(
                                            text: 'No', color: whiteColor),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.2,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 3, 216, 110),
                                              shadowColor: blackColor,
                                              elevation: 1),
                                          onPressed: () async {
                                            await DatabaseHelper()
                                                .deletPinCode();
                                            pinController.clear();
                                            Get.back();
                                          },
                                          child: normalText(
                                              text: 'Yes', color: whiteColor)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      child: boldText(
                          text: 'Click Here',
                          color: Colors.blueAccent,
                          size: 16.0))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
