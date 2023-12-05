import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

Widget roundedTextField({labelText, hintText, controller, textInputType}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SizedBox(
      height: 50,
      child: TextField(
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
          labelStyle: const TextStyle(color: greyColor),
          hintText: hintText,
          hintStyle: const TextStyle(color: greyColor),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: greenColor),
          ),
        ),
        cursorColor: whiteColor,
        style: const TextStyle(
          color: whiteColor,
        ),
      ),
    ),
  );
}
