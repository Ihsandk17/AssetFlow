import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:daxno_task/controllers/home_controller.dart';
import 'package:daxno_task/sreens/home_screen/components/flow_chart.dart';
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
                  padding: const EdgeInsets.only(top: 160),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              boxShadow: [
                                BoxShadow(blurRadius: 1.0),
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0))),
                          height: 80,
                          //width: MediaQuery.of(context).size.width / 3 * 2.8,

                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
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
                      Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only()),
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

                                print("change data!!!! ${changeData}");
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
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 1.0, color: Colors.black)
                      ],
                      color: prussianBlue,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20)),
                    ),
                    //width: MediaQuery.of(context).size.width / 3 * 2.8,
                    height: MediaQuery.of(context).size.width / 1.95,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                  text: totalNetworth,
                                ),
                                const SizedBox(
                                  height: 5.0,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                normalText(
                                  text: thisMonthIncom,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                normalText(
                                  text: thisMonthExpense,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 25),
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
                                const SizedBox(
                                  height: 39,
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
                                const SizedBox(
                                  height: 5,
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                                    title: accounts[index]['title'],
                                    amount:
                                        '\$${accounts[index]['currentamount']}',
                                  );
                                },
                              ),
                            );
                          }
                        })
                  ]),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: greyColor,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    height: 40,
                    width: 300,
                    color: prussianBlue,
                    child: Center(child: boldText(text: allTransiction)),
                  ),
                ),
                const SizedBox(
                  height: 10,
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

                        return Card(
                          color: cornflowerBlue,
                          child: ListTile(
                            onTap: () {
                              // Handle tap on the transaction
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
                              text: DateFormat('MMM d, y')
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
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}
