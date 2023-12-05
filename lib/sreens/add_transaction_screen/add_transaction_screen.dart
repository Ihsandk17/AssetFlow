import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/add_trans_controller.dart';
import 'package:daxno_task/sreens/state_screen/components/dropdown_button.dart';
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
  //final TextEditingController desController = TextEditingController();

  final items = ['expended', 'added'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 4,
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
                    padding: const EdgeInsets.only(bottom: 10),
                    child: boldText(text: newTrans),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            roundedTextField(
              hintText: "i.e purchased",
              labelText: "Transaction Name",
              textInputType: TextInputType.name,
              controller: nameController,
            ),
            const SizedBox(height: 30),
            roundedTextField(
              hintText: "i.e 1000",
              labelText: "Amount",
              textInputType: TextInputType.number,
              controller: amountController,
            ),
            // const SizedBox(height: 25),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20.0),
            //     child: Text(
            //       "(Optional)",
            //       style: TextStyle(color: greyColor),
            //     ),
            //   ),
            // ),
            // roundedTextField(
            //   hintText: "i.e: about transaction",
            //   labelText: "Description",
            //   textInputType: TextInputType.text,
            //   controller: desController,
            // ),
            const SizedBox(height: 30),
            //choose expand or added
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.05,
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
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.05,
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Retrieve transaction name and amount
                final String transName = nameController.text;
                final String transAmount = amountController.text;
                // final String transDes = desController.text;

                try {
                  //Create a transaction object
                  TransactionModel transaction = TransactionModel(
                    accountId: 0,
                    transactionType: controller.selectedTransType.value,
                    transactionName: transName,
                    // transactionDes: transDes,
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
                  //desController.text = '';
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
