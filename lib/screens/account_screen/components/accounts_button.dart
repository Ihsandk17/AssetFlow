import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

class AccountButtons extends StatelessWidget {
  final String title;
  final String amount;
  final double width;
  final double height;
  final Gradient color;
  final VoidCallback onPress;
  final VoidCallback? onLongPress;
  final Icon? icon;

  const AccountButtons({
    Key? key,
    required this.title,
    required this.amount,
    required this.width,
    required this.height,
    this.color = buttonColor2,
    this.icon,
    required this.onPress,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(blurRadius: 2.0, color: blackColor)],
        ),
        child: Stack(
          children: [
            if (icon != null)
              Positioned(
                  right: screenWidth * 0.02,
                  top: screenHeight * 0.015,
                  child: icon!),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
