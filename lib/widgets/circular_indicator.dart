import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

Widget circularIndicator({color = whiteColor}) {
  return Center(
    child: CircularProgressIndicator(color: color),
  );
}
