import 'package:daxno_task/utils/database_helper.dart';
import 'package:get/get.dart';

import '../utils/transaction_model.dart';

class AccController extends GetxController {
  RxInt selectedIndex = RxInt(-1);
  RxString selectedAccountTitle = RxString('');
  RxDouble selectedCurrentAmount = RxDouble(0.0);
  RxList<TransactionModel> selectedTransactions = RxList<TransactionModel>();

  void setSelectedAccount(int index, String title, double currentAmount) async {
    selectedIndex.value = index;
    selectedAccountTitle.value = title;
    selectedCurrentAmount.value = currentAmount;

    // Fetch transactions for the selected account
    selectedTransactions.value =
        await DatabaseHelper().getTransactionsForAccount(title);
  }

  // New method to initialize with the first account
  void initialAccount(List<Map<String, dynamic>> accounts) {
    if (accounts.isNotEmpty) {
      setSelectedAccount(
        0,
        accounts[0]['title'],
        accounts[0]['currentamount'].toDouble(),
      );
    }
  }

//update transactions list
  void updateTransactions(List<TransactionModel> transactions) {
    selectedTransactions.assignAll(transactions);
  }

//Method to retrieve  added transactions for the selected account
  double addedTrans() {
    double added = 0.0;

    for (TransactionModel transaction in selectedTransactions) {
      if (transaction.transactionType == 'added') {
        added += transaction.transactionAmount;
      }
    }
    return added;
  }

  //Method to retrieve expended transactions for the selected account
  double expendedTrans() {
    double expend = 0.0;
    for (TransactionModel transaction in selectedTransactions) {
      if (transaction.transactionType == 'expended') {
        expend += transaction.transactionAmount;
      }
    }
    return expend;
  }
}
