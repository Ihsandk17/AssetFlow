import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/constants/const.dart';
import 'package:flutter/material.dart';

Widget moreScreenButtons(
    {width, height, icons, String? title, required onPress}) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.yellow],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          boxShadow: [BoxShadow(blurRadius: 1.5, color: blackColor)],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.greenAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, height: 30, child: icons),
            const SizedBox(
              height: 10,
            ),
            Text(
              title!,
              style: const TextStyle(
                color: blackColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
