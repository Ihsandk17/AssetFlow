import 'package:daxno_task/constants/colors.dart';
import 'package:flutter/material.dart';

class AccountButtons extends StatelessWidget {
  final String title;
  final String amount;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPress;

  const AccountButtons({
    Key? key,
    required this.title,
    required this.amount,
    required this.width,
    required this.height,
    this.color = cornflowerBlue,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
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
    );
  }
}
