import 'package:daxno_task/sreens/state_screen/components/calender.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/const.dart';
import '../../controllers/state_controller.dart';
import '../../utils/database_helper.dart';
import 'components/dropdown_button.dart';

class StateScreen extends StatelessWidget {
  StateScreen({Key? key}) : super(key: key);

  final StateController controller = Get.put(StateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 3.7,
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black)],
                color: prussianBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<List<String>>(
                    future: DatabaseHelper().getAllAccountNames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return circularIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 43, right: 10),
                          child: normalText(
                              text: "Account Not Found!", color: greyColor),
                        ); // or any other fallback widget
                      } else {
                        List<String> accountNames = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.only(top: 43),
                          child: DropDownButtonAcc(
                            item: accountNames,
                            onSelected: (selectedAcount) async {
                              controller.selectedAccountName.value =
                                  // ignore: await_only_futures
                                  await selectedAcount;
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.28,
              width: MediaQuery.of(context).size.width / 1.01,
              child: Obx(() {
                var selectedAccountName = controller.selectedAccountName.value;

                return CalenderClass(selectedAccountName: selectedAccountName);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
