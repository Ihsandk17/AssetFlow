import 'package:flutter/material.dart';

const Color prussianBlue = Color.fromRGBO(31, 72, 115, 1);
const Color darkPrussianBlue = Color.fromRGBO(2, 27, 54, 1);
const Color cornflowerBlue = Color.fromRGBO(113, 169, 181, 1);
const Color orengColor = Color.fromRGBO(232, 107, 17, 1);
const Color yelloColor = Color.fromRGBO(226, 202, 13, 1);
const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
const Color blackColor = Color.fromRGBO(0, 0, 0, 1);
const Color greyColor = Color.fromRGBO(138, 130, 130, 1);
const Color greenColor = Colors.greenAccent;

const List<Color> gradientColors = [
  Color.fromRGBO(74, 147, 226, 1),
  Color.fromRGBO(5, 50, 98, 1),
];
const Gradient buttonColor = LinearGradient(
  colors: [
    Color.fromARGB(255, 38, 152, 245),
    Color.fromARGB(255, 135, 248, 193)
  ],
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
);
const Gradient buttonColor2 = LinearGradient(
  colors: [
    Color.fromARGB(255, 38, 152, 245),
    Color.fromARGB(255, 135, 248, 193)
  ],
  end: Alignment.bottomRight,
  begin: Alignment.topLeft,
);

const List<Color> transColor = [
  Color.fromARGB(255, 0, 109, 199),
  prussianBlue,
];

// Define a gradient color
const Gradient customGradient = LinearGradient(
  colors: [prussianBlue, darkPrussianBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
