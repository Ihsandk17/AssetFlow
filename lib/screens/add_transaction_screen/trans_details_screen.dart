import 'package:daxno_task/utils/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/const.dart';
import '../../widgets/text_style.dart';

class TransDetailsScreen extends StatelessWidget {
  const TransDetailsScreen(
      {super.key, required this.transaction, required this.accountName});

  final TransactionModel transaction;
  final String accountName;

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.048, left: screenWidth * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        )),
                    SizedBox(width: screenWidth * 0.16),
                    boldText(
                      text: title,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldText(
                    text: accName,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                boldText(text: accountName, color: whiteColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(
                    text: transTitle,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(
                    text: transaction.transactionName, color: whiteColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(
                    text: transType,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(
                    text: transaction.transactionType,
                    color: transaction.transactionType == 'expended'
                        ? Colors.red
                        : greenColor),
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
                        .format(transaction.transactionTime),
                    color: whiteColor),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(
                    text: amount,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(
                    text: "\$${transaction.transactionAmount}",
                    color: transaction.transactionType == 'expended'
                        ? Colors.red
                        : greenColor)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                normalText(
                    text: transDesc,
                    color: const Color.fromARGB(255, 187, 179, 179)),
                normalText(text: transaction.transactionDes, color: whiteColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
