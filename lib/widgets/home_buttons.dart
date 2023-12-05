import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

Widget homeButtons(
    {double width = 100,
    double height = 100,
    String? amount,
    String? title,
    onPress}) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1.5, color: blackColor)],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: cornflowerBlue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              amount!,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
