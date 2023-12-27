import 'dart:math';

import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/state_controller.dart';
import 'package:daxno_task/utils/transaction_model.dart';
import 'package:daxno_task/widgets/circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../utils/database_helper.dart';

class CalenderClass extends StatefulWidget {
  const CalenderClass({Key? key, required this.selectedAccountName})
      : super(key: key);

  final String selectedAccountName;

  @override
  // ignore: library_private_types_in_public_api
  _CalenderClassState createState() => _CalenderClassState();
}

class _CalenderClassState extends State<CalenderClass> {
  final StateController controller = Get.put(StateController());

  late Future<List<Meeting>> _dataSource;

  late List<TransactionModel> transactions;

  @override
  void initState() {
    super.initState();

    // Listen to changes in selectedAccountName
    ever(controller.selectedAccountName, (newAccountName) {
      _dataSource = _getDataSource(newAccountName);
      setState(() {});
    });

    _dataSource = _getDataSource(controller.selectedAccountName.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20.0)),
        child: FutureBuilder<List<Meeting>>(
          future: _dataSource,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return _buildCalendar(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCalendar(List<Meeting>? dataSource) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: calendarColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: SfCalendar(
        maxDate: DateTime.now(),
        view: CalendarView.month,
        showNavigationArrow: true,
        headerHeight: 50,
        initialSelectedDate: DateTime.now(),
        headerStyle: const CalendarHeaderStyle(
          textStyle: TextStyle(color: whiteColor),
          textAlign: TextAlign.center,
        ),
        viewHeaderStyle: const ViewHeaderStyle(
          dayTextStyle: TextStyle(color: whiteColor),
          backgroundColor: greyColor,
        ),
        selectionDecoration:
            BoxDecoration(border: Border.all(color: greyColor)),
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaItemHeight: 60,
          agendaViewHeight: 300,
          agendaStyle: AgendaStyle(
            placeholderTextStyle: TextStyle(color: Colors.red),
          ),
        ),
        todayTextStyle: const TextStyle(
          color: prussianBlue,
        ),
        todayHighlightColor: greenColor,
        dataSource: MeetingDataSource(dataSource!),
        appointmentBuilder:
            (BuildContext context, CalendarAppointmentDetails details) {
          final Meeting meeting = details.appointments.first as Meeting;

          List<Color> myColors = [
            prussianBlue,
            blackColor,
            darkPrussianBlue,
            greyColor,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            // Add more colors as needed
          ];

          return Container(
            decoration: BoxDecoration(
              color: myColors[Random().nextInt(myColors.length)],
              // border: Border.all(
              //   color:
              //       Colors.primaries[Random().nextInt(Colors.primaries.length)],
              // ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.eventName,
                        style: TextStyle(
                          color: meeting.transactionType == 'added'
                              ? greenColor
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(meeting.from),
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        meeting.transactionType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        meeting.transactionAmount.toString(),
                        style: TextStyle(
                          color: meeting.transactionType == 'added'
                              ? greenColor
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Meeting>> _getDataSource(String accountName) async {
    final List<Meeting> meetings = <Meeting>[];

    // Fetch transactions for the selected account from the database
    transactions =
        await DatabaseHelper().getTransactionsForAccount(accountName);

    // Convert transactions to meetings
    for (var transaction in transactions) {
      meetings.add(
        Meeting(
          transaction.transactionName,
          transaction.transactionTime,
          transaction.transactionTime.add(const Duration(hours: 2)),
          prussianBlue,
          false,
          transaction.transactionName,
          transaction.transactionType,
          transaction.transactionAmount,
        ),
      );
    }

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.transactionName,
    this.transactionType,
    this.transactionAmount,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  // Additional properties for transactions
  String transactionName;
  String transactionType;
  double transactionAmount;
}
