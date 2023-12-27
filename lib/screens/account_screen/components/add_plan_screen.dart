import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/add_trans_controller.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/text_style.dart';

class AddNewPlan extends StatelessWidget {
  const AddNewPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Initialized add transaction controller for calling to calculate the totalNetworth and
    //and inserting changes to the  changes_total_amount table
    AddTransController addTransController = Get.put(AddTransController());
    final TextEditingController accNameController = TextEditingController();
    final TextEditingController currentAmountController =
        TextEditingController();
    final TextEditingController descController = TextEditingController();

    Future<void> insertNewAcc() async {
      String accName = accNameController.text;
      String desc = descController.text;
      int currentAmount = int.tryParse(currentAmountController.text) ?? 0;

      List<String> existingAccountNames =
          await DatabaseHelper().getAllAccountNames();
      if (existingAccountNames.contains(accName)) {
        Get.snackbar("Error!",
            "Account name '$accName' already exists. Please choose a different name.",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
        return;
      }

      await DatabaseHelper().insertAccount(accName, desc, currentAmount);
      addTransController.calculateTotalAmount();
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
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
                      ),
                    ),
                    const SizedBox(width: 70),
                    boldText(
                      text: "Add New Plan!",
                    ),
                  ],
                ),
                SizedBox(height: constraints.maxHeight > 600 ? 35 : 25),
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: transColor,
                          end: Alignment.bottomCenter,
                          begin: Alignment.topCenter),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: const Offset(0, 5), // Offset
                        )
                      ]),
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight > 600 ? 30 : 20),
                      roundedTextField(
                        labelText: "Account Name",
                        hintText: "Account Name",
                        textInputType: TextInputType.name,
                        controller: accNameController,
                      ),
                      SizedBox(height: constraints.maxHeight > 600 ? 30 : 20),
                      roundedTextField(
                        labelText: "Current Amount",
                        hintText: "Current Amount",
                        controller: currentAmountController,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: constraints.maxWidth > 600 ? 30 : 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            "(Optional)",
                            style: TextStyle(color: greyColor),
                          ),
                        ),
                      ),
                      roundedTextField(
                        hintText: "i.e: about transaction",
                        labelText: "Description",
                        textInputType: TextInputType.text,
                        controller: descController,
                      ),
                      SizedBox(height: constraints.maxWidth > 600 ? 50 : 30),
                      ElevatedButton(
                        onPressed: () {
                          insertNewAcc();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 109, 199)),
                        child: boldText(text: "create"),
                      ),
                      SizedBox(height: constraints.maxHeight > 600 ? 5 : 5),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
