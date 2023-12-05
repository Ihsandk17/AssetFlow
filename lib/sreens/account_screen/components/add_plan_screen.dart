import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/text_style.dart';

class AddNewPlan extends StatelessWidget {
  const AddNewPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController accNameController = TextEditingController();
    final TextEditingController currentAmountController =
        TextEditingController();

    //Function to handle the database insertion
    Future<void> insertNewAcc() async {
      String accName = accNameController.text;
      int currentAmount = int.tryParse(currentAmountController.text) ?? 0;

      //insert into database
      await DatabaseHelper().insertAccount(accName, currentAmount);
    }

    TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: whiteColor,
                  )),
              const SizedBox(width: 80),
              boldText(
                text: "Add New Plan!",
              ),
            ],
          ),
          const SizedBox(height: 30),
          roundedTextField(
              labelText: "Account Name",
              hintText: "Account Name",
              textInputType: TextInputType.name,
              controller: accNameController),
          const SizedBox(height: 30),
          roundedTextField(
              labelText: "Current Amount",
              hintText: "Current Amount",
              controller: currentAmountController,
              textInputType: TextInputType.number),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              insertNewAcc();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: cornflowerBlue),
            child: boldText(text: "create"),
          )
        ],
      ),
    );
  }
}
