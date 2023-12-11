// ignore_for_file: prefer_const_constructors

import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:daxno_task/screens/account_screen/components/accounts_button.dart';
import 'package:daxno_task/screens/account_screen/components/add_plan_screen.dart';
import 'package:daxno_task/screens/account_screen/components/barchart.dart';
import 'package:daxno_task/screens/add_transaction_screen/trans_details_screen.dart';
import 'package:daxno_task/screens/home_screen/components/account_detail_screen.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final AccController controller = Get.put(AccController());

    return Scaffold(
        extendBody: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.015),
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 0.12,
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
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.05,
                            right: screenWidth * 0.01),
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => const AddNewPlan());
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
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: boldText(text: "No Any Account Added!"),
                      ));
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
                                width: screenWidth * 0.43,
                                height: screenHeight * 0.19,
                                color: isSelected
                                    ? buttonColor
                                    : buttonColor2, // Highlight color
                                icon: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color:
                                            Color.fromARGB(255, 138, 251, 217),
                                      )
                                    : null,
                                title: accounts[index]['title'],
                                amount: '\$${accounts[index]['currentamount']}',

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
                                onLongPress: () {
                                  Get.to(() => AccountDetailScreen(
                                      accounts: accounts[index]));
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
                height: screenHeight * 0.3,
                width: screenWidth * 0.99,
                child: const BarChartSample(),
              ),

              SizedBox(height: screenHeight * 0.03),

              Padding(
                padding: EdgeInsets.all(screenWidth * 0.035),
                child: const Divider(
                  thickness: 1,
                  color: greyColor,
                ),
              ),

              //Selected account Transaction List
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      height: screenHeight * 0.04,
                      width: screenWidth * 0.6,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: transColor,
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                      child: Center(child: boldText(text: "Transactions")),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
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
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: screenHeight * 0.09,
                                  width: screenWidth * 0.98,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: transColor,
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: ListTile(
                                    onTap: () async {
                                      Get.to(() => TransDetailsScreen(
                                            transaction: transaction,
                                            accountName: controller
                                                .selectedAccountTitle.value,
                                          ));
                                    },
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
              SizedBox(height: screenHeight * 0.08)
            ],
          ),
        ));
  }
}
