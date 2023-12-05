// ignore_for_file: prefer_const_constructors

import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/controllers/acc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SfCartesianChart(
          borderColor: greyColor,
          primaryXAxis:
              CategoryAxis(majorTickLines: const MajorTickLines(size: 0)),
          primaryYAxis:
              NumericAxis(majorTickLines: const MajorTickLines(size: 0)),
          title: ChartTitle(
              text: controller.selectedAccountTitle.value,
              textStyle:
                  TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
          series: <BarSeries<TransData, String>>[
            BarSeries<TransData, String>(
              animationDuration: 1500,
              color: orengColor,
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
              width: 0.2,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
