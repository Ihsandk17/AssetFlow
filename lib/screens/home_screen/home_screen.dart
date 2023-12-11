import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:daxno_task/controllers/home_controller.dart';
import 'package:daxno_task/screens/add_transaction_screen/trans_details_screen.dart';
import 'package:daxno_task/screens/home_screen/components/account_detail_screen.dart';
import 'package:daxno_task/screens/home_screen/components/flow_chart.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:daxno_task/widgets/home_buttons.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  String selectedTP = "1M";

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  final HomeController controller = Get.put(HomeController());
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  void loadChartData() async {
    controller.calculateTotalAmount();
    await controller.calculateOneMonthIncome();
    await controller.calculateOneMonthExpense();
    await controller.updateLineChartData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final AccController accountController = Get.put(AccController());
    //List<TransactionModel> transactions = [];

    return Scaffold(
      extendBody: true,
      backgroundColor: darkPrussianBlue,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                // select time row for graph
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.21),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.015),
                        child: Container(
                          width: screenWidth * 1,
                          height: screenHeight * 0.099,
                          decoration: const BoxDecoration(
                              color: greenColor,
                              boxShadow: [
                                BoxShadow(blurRadius: 1.0),
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0))),
                          child: Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.04),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    child: boldText(
                                        text: "1M",
                                        color:
                                            controller.selectedTP.value == "1M"
                                                ? darkPrussianBlue
                                                : greyColor),
                                    onTap: () {
                                      controller.updateMaxXRange(30);
                                      controller.selectedTimePeriod("1M");
                                    },
                                  ),
                                  InkWell(
                                    child: boldText(
                                        text: "3M",
                                        color:
                                            controller.selectedTP.value == "3M"
                                                ? darkPrussianBlue
                                                : greyColor),
                                    onTap: () {
                                      controller.updateMaxXRange(90);
                                      controller.selectedTimePeriod("3M");
                                    },
                                  ),
                                  InkWell(
                                    child: boldText(
                                        text: "6M",
                                        color:
                                            controller.selectedTP.value == "6M"
                                                ? darkPrussianBlue
                                                : greyColor),
                                    onTap: () {
                                      controller.updateMaxXRange(180);
                                      controller.selectedTimePeriod("6M");
                                    },
                                  ),
                                  InkWell(
                                    child: boldText(
                                        text: "1Y",
                                        color:
                                            controller.selectedTP.value == "1Y"
                                                ? darkPrussianBlue
                                                : greyColor),
                                    onTap: () {
                                      controller.updateMaxXRange(356);
                                      controller.selectedTimePeriod("1Y");
                                    },
                                  ),
                                  InkWell(
                                    child: boldText(
                                        text: "All",
                                        color:
                                            controller.selectedTP.value == "All"
                                                ? darkPrussianBlue
                                                : greyColor),
                                    onTap: () {
                                      controller.updateMaxXRange(140);
                                      controller.selectedTimePeriod("All");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.29,
                        width: double.infinity,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: controller.updateLineChartData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return circularIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.hasData) {
                                final changeData = snapshot.data;

                                // ignore: avoid_print
                                print("change data!!!! $changeData");
                                return LineChart2(
                                  totalChangedData: changeData!,
                                  homeController: controller,
                                );
                                // return LineChart(
                                //   totalChangedData: changeData!,
                                // );
                              } else {
                                return Center(
                                  child: boldText(
                                      text: "No data for the graph!",
                                      color: whiteColor),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //top card
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.015),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 1.0, color: Colors.black)
                      ],
                      color: prussianBlue,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20)),
                    ),
                    width: screenWidth * 1,
                    height: screenHeight * 0.24,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.07),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(
                                text: totalNetworth,
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Obx(
                                () {
                                  double totalAmount =
                                      controller.totalAmount.value;
                                  return boldText(
                                    text: '\$$totalAmount',
                                  );
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              normalText(
                                text: thisMonthIncom,
                              ),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              normalText(
                                text: thisMonthExpense,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.06),
                                  SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: Image.asset(
                                      icReward,
                                    ),
                                  ),
                                  boldText(
                                    text: myRewards,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: Image.asset(icIncome),
                                  ),
                                  Obx(
                                    () => normalText(
                                      text:
                                          "\$${controller.oneMonthIncom.value.toString()}",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.006,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: SizedBox(
                                      height: 19,
                                      width: 19,
                                      child: Image.asset(icDecrease),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Obx(
                                    () => normalText(
                                        text:
                                            "\$${controller.oneMonthExpense.value.toString()}",
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder(
                        future: DatabaseHelper().getAllAccounts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return circularIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Map<String, dynamic>> accounts =
                                snapshot.data!;

                            if (accounts.isEmpty) {
                              return boldText(text: "No account found");
                            }
                            Future.delayed(Duration.zero, () {
                              accountController.initialAccount(accounts);
                            });

                            return Row(
                              children: List.generate(
                                accounts.length,
                                (index) {
                                  return homeButtons(
                                    onPress: () {
                                      Get.to(() => AccountDetailScreen(
                                            accounts: accounts[index],
                                          ));
                                    },
                                    title: accounts[index]['title'],
                                    amount:
                                        '\$${accounts[index]['currentamount']}',
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.13,
                                  );
                                },
                              ),
                            );
                          }
                        })
                  ]),
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: greyColor,
                thickness: 1,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.8,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      gradient: LinearGradient(
                          colors: transColor,
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  child: Center(child: boldText(text: allTransiction)),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),

                //All Transiction List
                FutureBuilder<List<TransactionModel>>(
                  future: controller.allTransactions(),
                  builder: (contex, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return circularIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      transactions = snapshot.data!;

                      if (transactions.isEmpty) {
                        // Display a message when there are no transaction
                        return Center(
                            child:
                                boldText(text: "Not found any Transaction!"));
                      }
                    }
                    return Column(
                      children: List.generate(transactions.length, (index) {
                        TransactionModel transaction = transactions[index];

                        var isAdded = transaction.transactionType;

                        return Container(
                          height: screenHeight * 0.09,
                          width: screenWidth * 0.98,
                          margin: EdgeInsets.only(bottom: screenHeight * 0.008),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: transColor,
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            onTap: () async {
                              int? accountId = transaction.accountId;
                              String? accountName = await DatabaseHelper()
                                  .getAccountName(accountId);

                              // Handle tap on the transaction
                              Get.to(() => TransDetailsScreen(
                                    transaction: transaction,
                                    accountName: accountName!,
                                  ));
                            },
                            leading: isAdded == 'added'
                                ? const Icon(
                                    Icons.arrow_downward,
                                    size: 30,
                                    color: greenColor,
                                  )
                                : const Icon(
                                    Icons.arrow_upward,
                                    size: 30,
                                    color: Color.fromARGB(255, 249, 47, 33),
                                  ),
                            title: boldText(
                              text: transaction.transactionName,
                              color: whiteColor,
                            ),
                            subtitle: normalText(
                              text: DateFormat('MMM dd, y')
                                  .format(transaction.transactionTime),
                              color: const Color.fromARGB(255, 199, 191, 191),
                            ),
                            trailing: boldText(
                              text:
                                  '\$${transaction.transactionAmount.toString()}',
                              color: isAdded == 'added'
                                  ? greenColor
                                  : const Color.fromARGB(255, 249, 47, 33),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.08)
          ],
        ),
      ),
    );
  }
}
