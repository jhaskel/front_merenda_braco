import 'package:flutter/material.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:pie_chart/pie_chart.dart';

class Pizzai extends StatelessWidget {
  Map<String, double> dataMap;

   Pizzai(this.dataMap, {
    Key key,
    @required this.colorList,
  }) : super(key: key);

  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: Cores.colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
    );
  }
}