// ignore_for_file: avoid_print, empty_catches

import 'package:daxno_task/screens/account_screen/account_screen.dart';
import 'package:daxno_task/screens/add_transaction_screen/add_transaction_screen.dart';
import 'package:daxno_task/screens/home_screen/home_screen.dart';
import 'package:daxno_task/screens/more_screen/more_screen.dart';
import 'package:daxno_task/screens/state_screen/state_screen.dart';
import 'package:daxno_task/utils/database_helper.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //bottom app bar
  var currentIndex = 0.obs;

  var totalAmount = 0.0.obs;
  var oneMonthIncom = 0.0.obs;
  var oneMonthExpense = 0.0.obs;

  final List screen = [
    const HomeScreen(),
    StateScreen(),
    const AccountScreen(),
    const MoreScreen(),
    AddTransScreen()
  ].obs;

  var maxXRange = 8.obs;
  void updateMaxXRange(int range) {
    maxXRange.value = range;
  }

  RxString selectedTP = "1M".obs;
  void selectedTimePeriod(String period) {
    selectedTP.value = period;
  }

// Method to retrieve all account transactions and sort them by time
  Future<List<TransactionModel>> allTransactions() async {
    try {
      List<TransactionModel> transactions =
          await DatabaseHelper().getAllTransactions();

      // Sort transactions by time (you can adjust the sorting order as needed)
      transactions
          .sort((a, b) => b.transactionTime.compareTo(a.transactionTime));

      return transactions;
    } catch (e) {
      print('Error fetching account transactions: $e');
      return [];
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

      this.totalAmount.value = totalAmount;
    } catch (e) {
      print('Error calculating total amount: $e');
    }
  }

//Method to retrieve added transactions in the last one month
  Future<void> calculateOneMonthIncome() async {
    try {
      // Get all transactions
      List<TransactionModel> transactions =
          await DatabaseHelper().getAllTransactions();

      // Get the current date
      DateTime currentDate = DateTime.now();

      // Calculate the start date for the last one month
      DateTime startDate = currentDate.subtract(const Duration(days: 30));

      // Filter transactions for the last one month and with 'added' type
      List<TransactionModel> addedTransactions = transactions
          .where((transaction) =>
              transaction.transactionType == 'added' &&
              transaction.transactionTime.isAfter(startDate))
          .toList();

      // Calculate the total amount of added transactions
      double oneMonthIncome = addedTransactions.fold(
          0.0, (total, transaction) => total + transaction.transactionAmount);

      // Update the state variable
      // ignore: unnecessary_this
      this.oneMonthIncom.value = oneMonthIncome;
    } catch (e) {}
  }

  //Method to retrieve expended transactions in the last one month
  Future<void> calculateOneMonthExpense() async {
    try {
      // Get all transactions
      List<TransactionModel> transactions =
          await DatabaseHelper().getAllTransactions();

      // Get the current date
      DateTime currentDate = DateTime.now();

      // Calculate the start date for the last one month
      DateTime startDate = currentDate.subtract(const Duration(days: 30));

      // Filter transactions for the last one month and with 'added' type
      List<TransactionModel> addedTransactions = transactions
          .where((transaction) =>
              transaction.transactionType == 'expended' &&
              transaction.transactionTime.isAfter(startDate))
          .toList();

      // Calculate the total amount of added transactions
      double oneMonthExpense = addedTransactions.fold(
          0.0, (total, transaction) => total + transaction.transactionAmount);

      // Update the state variable
      // ignore: unnecessary_this
      this.oneMonthExpense.value = oneMonthExpense;
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> updateLineChartData() async {
    try {
      // Get total amount changes from the database
      List<Map<String, dynamic>> totalChanges =
          await DatabaseHelper().getTotalAmountChanges();
      return totalChanges;
    } catch (e) {
      print('Error updating line chart data: $e');
    }
    return [];
  }
}
