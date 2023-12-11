import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: boldText(text: "Profile!"),
    );
  }
}
