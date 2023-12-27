import 'dart:io';

import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/pincode_controller.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_screen/home.dart';

class PinCodeScreen extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  PinCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PinController controller = PinController();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: controller.updatePhoto(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading profile photo');
                  } else {
                    return CircleAvatar(
                      backgroundColor: prussianBlue,
                      radius: screenWidth * 0.18,
                      backgroundImage: controller.profilePhoto.value == null
                          ? const AssetImage(logo)
                          : FileImage(File(controller.profilePhoto.value!))
                              as ImageProvider<Object>?,
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: FutureBuilder(
                    future: DatabaseHelper().getProfileName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return circularIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        String? name = snapshot.data;
                        return name != null
                            ? boldText(
                                text: name,
                                size: 24.0,
                              )
                            : boldText(
                                text: "Assets Flow",
                                size: 24.0,
                              );
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.1,
                  left: screenWidth * 0.15,
                  right: screenWidth * 0.15,
                ),
                child: SizedBox(
                  height: screenHeight * 0.06,
                  child: Obx(
                    () => TextField(
                      controller: pinController,
                      textAlign: TextAlign.center,
                      obscureText: controller.isObscure.value,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: whiteColor),
                      cursorColor: whiteColor,
                      decoration: InputDecoration(
                        hintText: 'Enter Pin Code',
                        hintStyle: const TextStyle(color: greyColor),
                        labelText: 'Pin Code',
                        labelStyle: const TextStyle(color: greenColor),
                        focusColor: greenColor,
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(color: greenColor),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.updateObscure();
                          },
                          icon: Icon(
                            controller.isObscure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: controller.isObscure.value
                                ? greyColor
                                : greenColor,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          borderSide: BorderSide(color: greenColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              ElevatedButton(
                onPressed: () async {
                  String enteredPin = pinController.text;
                  bool isAuthenticated =
                      await DatabaseHelper().verifyPinCode(enteredPin);
                  if (isAuthenticated) {
                    // Navigate to the main part of your app
                    Get.to(() => const Home());
                  } else {
                    // Show error message
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Invalid Pin Code'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: boldText(text: "Submit", color: prussianBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
