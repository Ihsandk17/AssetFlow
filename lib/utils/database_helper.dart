// ignore_for_file: avoid_print, use_rethrow_when_possible, unnecessary_brace_in_string_interps

import 'package:daxno_task/utils/transaction_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE account_name (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            currentamount REAL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY,
      accountId INTEGER,
      transactionType TEXT,
      transactionName TEXT,
  
      transactionTime TIMESTAMP,
      transactionAmount REAL,
      FOREIGN KEY (accountId) REFERENCES account_name(id)
    )
  ''');

        // Create a new table to log changes in the total amount
        await db.execute('''
        CREATE TABLE total_amount_changes (
          id INTEGER PRIMARY KEY,
          changeAmount REAL,
          changeTime TIMESTAMP
        )
      ''');
      },
    );
  }

  //Create a Method to insert new account into database
  Future<void> insertAccount(String accName, int currentAmount) async {
    final Database db = await database;

    await db.insert(
      'account_name',
      {
        'title': accName,
        'currentamount': currentAmount,
        'createdAt': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Log the change in total_amount_changes for the new account
    // await db.insert(
    //   'total_amount_changes',
    //   {
    //     'changeType': 'added_account',
    //     'changeAmount': currentAmount.toDouble(),
    //     'changeTime': DateTime.now().toIso8601String(),
    //   },
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
  }

  // Method to get all accounts
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    final Database db = await database;

    return await db.query('account_name');
  }

  //insert transaction
  Future<void> insertTransaction(
      String accountName, TransactionModel transaction) async {
    final Database db = await database;
    try {
      // Get the account ID using the account name
      int? accountId = await getAccountIdFromAccountName(accountName);
      // Check if the account exists
      if (accountId != null) {
        // Assign the account ID to the transaction
        transaction.accountId = accountId;

        // Insert the transaction into the 'transactions' table
        await db.insert(
          'transactions',
          {
            'accountId': transaction.accountId,
            'transactionType': transaction.transactionType,
            'transactionName': transaction.transactionName,
            //'transactionDes': transaction.transactionDes,
            'transactionTime': transaction.transactionTime.toIso8601String(),
            'transactionAmount': transaction
                .transactionAmount, // Ensure it's treated as a double
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Update the account's current amount based on the transaction type
        await updateAccountAmount(
          accountId,
          transaction.transactionType,
          transaction.transactionAmount,
        );

        print('Transaction inserted successfully!');
      } else {
        throw Exception("Account not found");
      }
    } catch (e) {
      print('Error inserting transaction: $e');
      // Handle the error, show a message, or throw the exception again
      throw e;
    }
  }

//Updeate the account amount after transaction
  Future<void> updateAccountAmount(
      int accountId, String transactionType, double transactionAmount) async {
    final Database db = await database;
    // Get the current amount of the account
    double? currentAmount = await getCurrentAmount(accountId);
    if (currentAmount != null) {
      if (transactionType == 'expended') {
        currentAmount = currentAmount - transactionAmount;
      } else if (transactionType == 'added') {
        currentAmount = currentAmount + transactionAmount;
      }

      // Update the account's current amount in the 'account_name' table
      await db.update(
        'account_name',
        {'currentamount': currentAmount},
        where: 'id = ?',
        whereArgs: [accountId],
      );

      // Insert a record into the total_amount_changes table
      // await db.insert(
      //   'total_amount_changes',
      //   {
      //     'changeType': transactionType,
      //     'changeAmount': transactionAmount,
      //     'changeTime': DateTime.now().toIso8601String(),
      //   },
      //   conflictAlgorithm: ConflictAlgorithm.replace,
      // );
    }
  }

  //Method to get the current amount of an account
  Future<double?> getCurrentAmount(int accountId) async {
    final Database db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'account_name',
      columns: ['currentamount'],
      where: 'id = ?',
      whereArgs: [accountId],
    );
    if (result.isNotEmpty) {
      return result.first['currentamount'] as double?;
    } else {
      return null;
    }
  }

  //Method to retrieve all accounts titles
  Future<List<String>> getAllAccountNames() async {
    final Database db = await database;

    List<Map<String, dynamic>> result =
        await db.query('account_name', columns: ['title']);
    List<String> accountNames =
        List<String>.from(result.map((e) => e['title'] as String));

    return accountNames;
  }

// Delete account and related transactions if exist
  Future<void> deleteAccount(int accountId) async {
    final Database db = await database;
    // Ensure the tables are created
    await initDatabase();
    // Delete transactions associated with the account if the 'transactions' table exists
    final transactionsCount = Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='transactions'",
      [],
    ));
    if (transactionsCount != null && transactionsCount > 0) {
      await db.delete(
        'transactions',
        where: 'accountId = ?',
        whereArgs: [accountId],
      );
    }
    // Delete account from 'account_name' table
    await db.delete(
      'account_name',
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  //Method to retrieve account id using account name
  Future<int?> getAccountIdFromAccountName(String accountName) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'account_name',
      columns: ['id'],
      where: 'title = ?',
      whereArgs: [accountName],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    } else {
      return null; // Account not found
    }
  }

// Method to get transactions for a specific account
  Future<List<TransactionModel>> getTransactionsForAccount(
      String accountName) async {
    final Database db = await database;
    // Get the account ID using the account name
    int? accountId = await getAccountIdFromAccountName(accountName);

    if (accountId != null) {
      List<Map<String, dynamic>> result = await db.query(
        'transactions',
        where: 'accountId = ?',
        whereArgs: [accountId],
      );
      // Convert the result to a list of TransactionModel objects
      List<TransactionModel> transactions = result
          .map((Map<String, dynamic> map) => TransactionModel(
                accountId: map['accountId'],
                transactionType: map['transactionType'],
                transactionName: map['transactionName'],
                // transactionDes: map['transactionDes'],
                transactionTime: DateTime.parse(map['transactionTime']),
                transactionAmount: (map['transactionAmount']).toDouble(),
              ))
          .toList();

      return transactions;
    } else {
      return []; // Account not found
    }
  }

// Method to get all transactions of all accounts
  Future<List<TransactionModel>> getAllTransactions() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('transactions');
    // Convert the result to a list of TransactionModel objects
    List<TransactionModel> transactions = result
        .map((Map<String, dynamic> map) => TransactionModel(
              accountId: map['accountId'],
              transactionType: map['transactionType'],
              transactionName: map['transactionName'],
              // transactionDes: map['transactionDes'],
              transactionTime: DateTime.parse(map['transactionTime']),
              transactionAmount: (map['transactionAmount']).toDouble(),
            ))
        .toList();
    return transactions;
  }

  //Method to insert changes in total amount into total_amount_changes table
  Future<void> totalAmountChange(double totalAmount) async {
    final Database db = await database;

    await db.insert(
      'total_amount_changes',
      {
        'changeAmount': totalAmount,
        'changeTime': DateTime.now().toIso8601String().substring(0, 19),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("changes noted in total_amount_changes table ${totalAmount}");
  }

  //Method to Get total amount changes
  Future<List<Map<String, dynamic>>> getTotalAmountChanges() async {
    final Database db = await database;
    return await db.query('total_amount_changes');
  }
}
