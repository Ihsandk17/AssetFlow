import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

Widget roundedTextField(
    {labelText, hintText, controller, textInputType, isPass = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SizedBox(
      height: 50,
      child: Container(
        decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                  color: darkPrussianBlue,
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(1, 2))
            ]),
        child: TextField(
          obscureText: isPass,
          controller: controller,
          keyboardType: textInputType,
          focusNode: FocusNode(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            labelText: labelText,
            labelStyle: const TextStyle(color: blackColor),
            hintText: hintText,
            hintStyle: const TextStyle(color: greyColor),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: greenColor),
            ),
          ),
          cursorColor: blackColor,
          style: const TextStyle(
            color: blackColor,
          ),
        ),
      ),
    ),
  );
}
