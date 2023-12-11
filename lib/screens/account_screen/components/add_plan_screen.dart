// import 'package:daxno_task/constants/const.dart';
// import 'package:daxno_task/utils/database_helper.dart';
// import 'package:daxno_task/widgets/rounded_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../widgets/text_style.dart';

// class AddNewPlan extends StatelessWidget {
//   const AddNewPlan({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     final TextEditingController accNameController = TextEditingController();
//     final TextEditingController currentAmountController =
//         TextEditingController();

//     //Function to handle the database insertion
//     Future<void> insertNewAcc() async {
//       String accName = accNameController.text;
//       int currentAmount = int.tryParse(currentAmountController.text) ?? 0;

//       //insert into database
//       await DatabaseHelper().insertAccount(accName, currentAmount);
//     }

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: screenWidth * 0.015),
//             child: Container(
//               width: screenWidth * 1,
//               height: screenHeight * 0.12,
//               decoration: const BoxDecoration(
//                 boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black)],
//                 color: prussianBlue,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: screenHeight * 0.048, left: screenWidth * 0.01),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back,
//                           color: whiteColor,
//                         )),
//                     SizedBox(width: screenWidth * 0.16),
//                     boldText(
//                       text: "Add New Plan!",
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.07),
//           roundedTextField(
//             labelText: "Account Name",
//             hintText: "Account Name",
//             textInputType: TextInputType.name,
//             controller: accNameController,
//           ),
//           SizedBox(height: screenHeight * 0.04),
//           roundedTextField(
//             labelText: "Current Amount",
//             hintText: "Current Amount",
//             controller: currentAmountController,
//             textInputType: TextInputType.number,
//           ),
//           SizedBox(height: screenHeight * 0.05),
//           ElevatedButton(
//             onPressed: () {
//               insertNewAcc();
//               Get.back();
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: cornflowerBlue),
//             child: boldText(text: "Create"),
//           )
//         ],
//       ),
//     );
//   }
// }

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
                    backgroundColor: cornflowerBlue,
                  ),
                  child: boldText(text: "create"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
