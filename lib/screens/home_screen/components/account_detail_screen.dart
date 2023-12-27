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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: screenHeight * 0.7,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                gradient: buttonColor2),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                boldText(text: accounts['title'], color: blackColor),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.15, right: screenWidth * 0.15),
                  child: const Divider(
                    color: greyColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      normalText(
                          text: amount,
                          color: const Color.fromARGB(255, 219, 215, 215)),
                      normalText(
                          text: "\$${accounts['currentamount']}",
                          color: blackColor)
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
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      normalText(
                          text: dateTime,
                          color: const Color.fromARGB(255, 219, 215, 215)),
                      normalText(
                        text: DateFormat('MMM-dd-yyyy / hh:mm.aa')
                            .format(DateTime.parse(accounts['createdAt'])),
                        color: blackColor,
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
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          text: "Description:\t",
                          color: const Color.fromARGB(255, 219, 215, 215)),
                      Expanded(
                        child: Text(
                          accounts['description'],
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
