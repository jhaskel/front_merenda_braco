import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';

import 'package:syncfusion_flutter_charts/charts.dart';



class GrafCol2 extends StatelessWidget {
  List<Customer> listaDados;
  GrafCol2(this.listaDados);

  @override
  Widget build(BuildContext context) {


    return Scaffold(

        body: Center(
            child: Container(
                height: 550,
                child: SfCartesianChart(
                  // Initialize category axis
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    labelRotation: 300,
                  ),
                  primaryYAxis: NumericAxis(
                      axisLine: AxisLine(width: 0),
                      labelFormat: '{value}',

                      majorTickLines: MajorTickLines(size: 0)),

                  legend: Legend(
                      isVisible: false
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
                  series: <ChartSeries<Customer, String>>[
                    ColumnSeries<Customer, String>(
                      // Bind data source
                        dataLabelSettings: DataLabelSettings(
                            isVisible: false,
                            labelPosition: ChartDataLabelPosition.outside
                        ),

                        name: "CATEGORIAS",
                        dataSource: listaDados,
                        xValueMapper: (Customer sales, _) => sales.nome ,
                        yValueMapper: (Customer sales, _) => sales.valor.toDouble(),
                        pointColorMapper: (Customer sales, _) => sales.cor,


                    )
                  ],

                )
            )
        )
    );
  }
}

