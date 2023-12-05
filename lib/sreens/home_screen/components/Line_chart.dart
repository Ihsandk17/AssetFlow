import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  const LineChart({
    Key? key,
    required this.totalChangedData,
  }) : super(key: key);

  final List<Map<String, dynamic>> totalChangedData;
  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    print(widget.totalChangedData);
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          borderColor: Colors.transparent,
          plotAreaBorderWidth: 0,

          // Initialize category axis
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
          ),
          series: <LineSeries<Map<String, dynamic>, String>>[
            LineSeries<Map<String, dynamic>, String>(
              // Bind data source
              dataSource: widget.totalChangedData,
              xValueMapper: (Map<String, dynamic> data, _) =>
                  data['changeTime'].toString(),
              yValueMapper: (Map<String, dynamic> data, _) =>
                  data['changeAmount'] as double,
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
