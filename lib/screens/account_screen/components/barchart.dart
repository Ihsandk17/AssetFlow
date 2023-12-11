// ignore_for_file: prefer_const_constructors

import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/constants/const.dart';
import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartSample extends StatefulWidget {
  const BarChartSample({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BarChartSampleState createState() => _BarChartSampleState();
}

class TransData {
  TransData(this.sales);

  final double sales;
}

class _BarChartSampleState extends State<BarChartSample> {
  final AccController controller = Get.find();
  NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SfCartesianChart(
          borderWidth:
              0.0, // Set borderWidth to zero to remove the outer border

          borderColor: Colors.white,
          primaryXAxis: CategoryAxis(
            majorTickLines: const MajorTickLines(size: 0),
            //majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(size: 0),
            //  majorGridLines: const MajorGridLines(width: 0),
            numberFormat: currencyFormatter,
            labelStyle: TextStyle(color: Colors.white),
            labelAlignment: LabelAlignment.center,
          ),
          title: ChartTitle(
            text: controller.selectedAccountTitle.value,
            textStyle:
                TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            overflowMode: LegendItemOverflowMode.wrap,
            backgroundColor: cornflowerBlue,
            isResponsive: true,
          ),
          series: <BarSeries<TransData, String>>[
            BarSeries<TransData, String>(
              animationDuration: 1500,
              gradient: LinearGradient(colors: const [
                Color.fromARGB(255, 218, 5, 5),
                Color.fromARGB(255, 248, 95, 128)
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              dataSource: [
                TransData(controller.expendedTrans()),
              ],
              xValueMapper: (TransData sales, _) => '',
              yValueMapper: (TransData sales, _) => sales.sales,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: whiteColor),
                labelAlignment: ChartDataLabelAlignment.top,
                labelPosition: ChartDataLabelPosition.inside,
              ),
              width: 0.5,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              legendItemText: 'Expenses',
              legendIconType: LegendIconType.circle,
            ),
            BarSeries<TransData, String>(
              animationDuration: 1500,
              gradient: LinearGradient(colors: const [
                Color.fromARGB(255, 135, 248, 193),
                Color.fromARGB(255, 23, 215, 122),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              dataSource: [
                TransData(controller.addedTrans()),
              ],
              xValueMapper: (TransData sales, _) => '',
              yValueMapper: (TransData sales, _) => sales.sales,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: whiteColor),
                labelAlignment: ChartDataLabelAlignment.top,
                labelPosition: ChartDataLabelPosition.inside,
              ),
              width: 0.5,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              legendItemText: 'Income',
              legendIconType: LegendIconType.circle,
            ),
            BarSeries<TransData, String>(
              animationDuration: 1500,
              gradient: LinearGradient(
                colors: transColor,
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              dataSource: [
                TransData(controller.selectedCurrentAmount.value),
              ],
              xValueMapper: (TransData sales, _) => '',
              yValueMapper: (TransData sales, _) => sales.sales,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: whiteColor),
                labelAlignment: ChartDataLabelAlignment.top,
                labelPosition: ChartDataLabelPosition.inside,
              ),
              width: 0.5,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              legendItemText: 'Total Amount',
              legendIconType: LegendIconType.circle,
            ),
          ],
        ),
      ),
    );
  }
}
