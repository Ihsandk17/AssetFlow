import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';

class Backup extends StatelessWidget {
  const Backup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: boldText(text: "Backup!"),
    );
  }
}
