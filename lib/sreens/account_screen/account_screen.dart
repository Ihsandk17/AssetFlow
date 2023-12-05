import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:daxno_task/sreens/account_screen/components/accounts_button.dart';
import 'package:daxno_task/sreens/account_screen/components/add_plan_screen.dart';
import 'package:daxno_task/sreens/account_screen/components/barchart.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/const.dart';
import '../../utils/transaction_model.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccController controller = Get.put(AccController());

    return Scaffold(
        extendBody: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 4,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.black)
                    ],
                    color: prussianBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 35, right: 8),
                        child: TextButton(
                          onPressed: () {
                            Get.to(const AddNewPlan());
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                color: whiteColor,
                              ),
                              normalText(
                                text: "Add new plan",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Accounts
              FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getAllAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> accounts = snapshot.data!;

                    if (accounts.isEmpty) {
                      // Display a message when there are no accounts
                      return Center(
                          child: boldText(text: "Not found any Account!"));
                    }

                    Future.delayed(Duration.zero, () {
                      // Initialize with the first account
                      controller.initialAccount(accounts);
                    });

                    return Obx(
                      () => GridView.count(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: List.generate(
                          accounts.length,
                          (index) {
                            bool isSelected =
                                controller.selectedIndex.value == index;
                            return Center(
                              child: AccountButtons(
                                title: accounts[index]['title'],
                                amount: '\$${accounts[index]['currentamount']}',
                                width: 150,
                                height: 150,
                                color: isSelected
                                    ? prussianBlue
                                    : cornflowerBlue, // Highlight color
                                onPress: () async {
                                  controller.setSelectedAccount(
                                    index,
                                    accounts[index]['title'],
                                    accounts[index]['currentamount'].toDouble(),
                                  );

                                  // Fetch transactions for the selected account
                                  List<TransactionModel> transactions =
                                      await DatabaseHelper()
                                          .getTransactionsForAccount(
                                    controller.selectedAccountTitle.value,
                                  );

                                  // Update selected transactions in the controller
                                  controller.updateTransactions(transactions);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),

              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.02,
                child: const BarChartSample(),
              ),

              const SizedBox(height: 20),

              //Recent Transaction List
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      height: 30,
                      width: 200,
                      color: prussianBlue,
                      child: Center(child: boldText(text: "Transactions")),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      try {
                        if (controller.selectedTransactions.isEmpty) {
                          return Center(
                              child: boldText(text: "No transactions"));
                        } else {
                          return Column(
                            children: List.generate(
                              controller.selectedTransactions.length,
                              (index) {
                                var transaction =
                                    controller.selectedTransactions[index];
                                var isAdded = transaction.transactionType;
                                return Card(
                                  color: cornflowerBlue,
                                  child: ListTile(
                                    onTap: () async {},
                                    leading: isAdded == 'added'
                                        ? const Icon(
                                            Icons.arrow_downward,
                                            color: greenColor,
                                          )
                                        : const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.red,
                                          ),
                                    title: boldText(
                                      text: transaction.transactionName,
                                      color: whiteColor,
                                    ),
                                    subtitle: normalText(
                                      text: DateFormat('dd/MM/yyyy')
                                          .format(transaction.transactionTime),
                                      color: Color.fromARGB(255, 199, 191, 191),
                                    ),
                                    trailing: boldText(
                                      text:
                                          "\$${transaction.transactionAmount}",
                                      color: isAdded == 'added'
                                          ? greenColor
                                          : Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      } catch (e) {
                        return Center(
                            child:
                                boldText(text: "Error loading transactions"));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 60)
            ],
          ),
        ));
  }
}
