// ignore_for_file: avoid_print

import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:get/get.dart';

class AddTransController extends GetxController {
  RxString selectedAccount = ''.obs;
  RxString selectedTransType = ''.obs;
  RxString transName = ''.obs;
  RxString transDes = ''.obs;
  RxDouble transAmount = RxDouble(0.0);

  var totalAmount = 0.0.obs;

  void setTransactionDetails({
    String? account,
    String? transType,
    String? transName,
    String? transDes,
    double? transAmount,
  }) {
    if (account != null) selectedAccount.value = account;
    if (transType != null) selectedTransType.value = transType;
    if (transName != null) this.transName.value = transName;
    if (transAmount != null) this.transAmount.value = transAmount;
    if (transDes != null) this.transDes.value = transDes;
  }

  Future<void> insertNewTransaction() async {
    // Validate inputs if needed

    // Check if all required fields are filled
    if (selectedAccount.value.isEmpty ||
        selectedTransType.value.isEmpty ||
        transName.value.isEmpty ||
        transAmount.value == 0.0) {
      // Show an error message or handle the case where not all fields are filled
      return;
    }

    try {
      // Create a TransactionModel object
      TransactionModel transaction = TransactionModel(
          // Note: accountId will be updated in the insertTransaction method
          accountId: 0, // Placeholder value
          transactionType: selectedTransType.value,
          transactionName: transName.value,
          transactionTime: DateTime.now(),
          transactionAmount: transAmount.value,
          transactionDes: transDes.value);

      // Insert the new transaction into the database with the associated account
      await DatabaseHelper()
          .insertTransaction(selectedAccount.value, transaction);

      // Reset the form
      selectedAccount.value = '';
      selectedTransType.value = '';
      transName.value = '';
      transAmount.value = 0.0;
      transDes.value = '';
    } catch (e) {
      // Handle the exception, e.g., show an error message
      //print("Error inserting transaction: $e");
    }
  }

  //Method to calculate the total amount of all accounts
  void calculateTotalAmount() async {
    try {
      List<Map<String, dynamic>> accounts =
          await DatabaseHelper().getAllAccounts();

      double totalAmount = 0.0;

      for (var account in accounts) {
        totalAmount += account['currentamount'];
      }
      // print(
      //     "total amount: $totalAmount this.totalamount.value ${this.totalAmount.value}");

      // Log the change in total amount for all accounts, if changes ocure
      if (totalAmount != this.totalAmount.value) {
        // Update the total amount
        this.totalAmount.value = totalAmount;
        await DatabaseHelper().totalAmountChange(totalAmount);
      } else {
        print("total amount not updated");
      }
    } catch (e) {
      print('Error calculating total amount: $e');
    }
  }
}
