import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/add_trans_controller.dart';
import 'package:daxno_task/screens/state_screen/components/dropdown_button.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:daxno_task/widgets/rounded_text_field.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTransScreen extends StatelessWidget {
  AddTransScreen({super.key});

  final AddTransController controller = Get.put(AddTransController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  final items = ['expended', 'added'];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.015),
              child: Container(
                width: screenWidth * 1,
                height: screenHeight * 0.12,
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black)],
                  color: prussianBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: boldText(text: newTrans),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),

            roundedTextField(
              hintText: "i.e purchased",
              labelText: "Transaction Name",
              textInputType: TextInputType.name,
              controller: nameController,
            ),
            SizedBox(height: screenHeight * 0.04),
            roundedTextField(
              hintText: "i.e 1000",
              labelText: "Amount",
              textInputType: TextInputType.number,
              controller: amountController,
            ),
            SizedBox(height: screenHeight * 0.016),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.07),
                child: const Text(
                  "(Optional)",
                  style: TextStyle(color: greyColor),
                ),
              ),
            ),
            roundedTextField(
              hintText: "i.e: about transaction",
              labelText: "Description",
              textInputType: TextInputType.text,
              controller: desController,
            ),
            SizedBox(height: screenHeight * 0.04),
            //choose expand or added
            Container(
              height: screenHeight * 0.065,
              width: screenWidth * 0.95,
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  normalText(
                      text: "choose type: ", color: greyColor, size: 18.0),
                  DropDownButtonAcc(
                    item: items,
                    onSelected: (selectedTransType) {
                      controller.selectedTransType.value = selectedTransType;
                    },
                  ),
                ],
              ),
            ),

            //choos account
            SizedBox(height: screenHeight * 0.04),
            Container(
              height: screenHeight * 0.065,
              width: screenWidth * 0.95,
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  normalText(
                      text: "choose account: ", color: greyColor, size: 18.0),
                  FutureBuilder<List<String>>(
                    future: DatabaseHelper().getAllAccountNames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return normalText(
                            text: "No Account!",
                            color: greyColor); // or any other fallback widget
                      } else {
                        List<String> accountNames = snapshot.data!;

                        return DropDownButtonAcc(
                          item: accountNames,
                          onSelected: (selectedAccount) {
                            controller.selectedAccount.value = selectedAccount;
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () async {
                // Retrieve transaction name and amount
                final String transName = nameController.text;
                final String transAmount = amountController.text;
                final String transDes = desController.text;

                try {
                  //Create a transaction object
                  TransactionModel transaction = TransactionModel(
                    accountId: 0,
                    transactionType: controller.selectedTransType.value,
                    transactionName: transName,
                    transactionDes: transDes,
                    transactionTime: DateTime.now(),
                    transactionAmount: double.parse(transAmount),
                  );

                  // Insert the new transaction into the database
                  await DatabaseHelper().insertTransaction(
                    controller.selectedAccount.value,
                    transaction,
                  );

                  controller.calculateTotalAmount();

                  // Reset the form
                  controller.selectedAccount.value = '';
                  controller.selectedTransType.value = '';
                  nameController.text = '';
                  amountController.text = '';
                  desController.text = '';
                } catch (e) {
                  // Handle the exception, e.g., show an error message
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: cornflowerBlue),
              child: boldText(text: " Save "),
            )
          ],
        ),
      ),
    );
  }
}
