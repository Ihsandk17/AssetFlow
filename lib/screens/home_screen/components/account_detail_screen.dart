// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:daxno_task/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/text_style.dart';

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key, required this.accounts});

  final accounts;

  @override
  Widget build(BuildContext context) {
    print("accounts : $accounts");
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.015),
            child: Container(
              width: screenWidth * 1,
              height: screenHeight * 0.12,
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black)],
                color: prussianBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.055,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        )),
                  ),
                  Positioned(
                    top: screenHeight * 0.066,
                    left: screenWidth * 0.45,
                    child: boldText(
                      text: accounts['title'],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(
                    text: amount,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(
                    text: "\$${accounts['currentamount']}", color: whiteColor)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: const Divider(
              color: greyColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(
                    text: dateTime,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(
                  text: DateFormat('MMM-dd-yyyy / hh:mm.aa')
                      .format(DateTime.parse(accounts['createdAt'])),
                  color: whiteColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: const Divider(
              color: greyColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                normalText(
                    text: "Description",
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(text: accounts['description'], color: whiteColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
