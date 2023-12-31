// ignore_for_file: avoid_print

import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class StateController extends GetxController {
  RxString selectedMonth = ''.obs;
  Rx<CalendarView> selectedView = CalendarView.month.obs;
  RxString selectedAccountName = ''.obs;

  void updateSelectedAccountName(String accountName) {
    selectedAccountName.value = accountName;
  }

  //Method to return transactions
  Future<List<TransactionModel>> getTransactions() async {
    try {
      List<TransactionModel> transactions =
          await DatabaseHelper().getAllTransactions();

      return transactions;
    } catch (e) {
      print("Error in retriving transactions $e");
    }
    return [];
  }
}
