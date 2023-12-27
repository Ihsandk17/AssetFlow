import 'dart:io';

import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/more_controller.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:daxno_task/widgets/more_screen_buttons.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/profile_picture_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final MoreController controller = MoreController();

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
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.image.value != null) {
                          Get.to(
                            () => ProfilePictureScreen(
                              imagePath: controller.image.value,
                              heroTag: 'profilePicture',
                            ),
                          );
                        } else {
                          return;
                        }
                      },
                      child: Hero(
                          tag: 'profilePicture',
                          child: FutureBuilder(
                              future: controller.updatePhoto(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return circularIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return CircleAvatar(
                                    radius: screenWidth * 0.18,
                                    backgroundImage: controller.image.value !=
                                            null
                                        ? FileImage(
                                                File(controller.image.value!))
                                            as ImageProvider<Object>?
                                        : const NetworkImage(
                                            'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png'),
                                  );
                                }
                              })),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.050,
              ),
              FutureBuilder(
                  future: DatabaseHelper().getProfileName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return circularIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      String? name = snapshot.data;
                      final bool isNameAvailable = snapshot.hasData;

                      return isNameAvailable
                          ? boldText(text: name, textAlign: TextAlign.center)
                          : normalText(text: "Name not set yet!");
                    }
                  }),
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
