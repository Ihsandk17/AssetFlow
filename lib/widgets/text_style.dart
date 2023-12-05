import 'package:flutter/material.dart';

Widget normalText({text, color = Colors.white, size = 14.0}) {
  return Text(
    "$text",
    style: TextStyle(color: color, fontSize: size),
  );
}

Widget boldText({text, color = Colors.white, size = 20.0}) {
  return Text(
    "$text",
    style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold),
  );
}
