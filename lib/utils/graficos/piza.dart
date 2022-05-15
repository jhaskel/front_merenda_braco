
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Piza extends StatelessWidget {
  List<Customer> listaDados;
  Customer customer;
  Piza(this.listaDados,{this.customer});

  @override
  Widget build(BuildContext context) {
    var dados = listaDados.map((e) => e.valor);
    var total = dados.reduce((a, b) => a + b);
    print('totalx${total}');

    return Scaffold(
        body: Center(
            child: Container(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SfCircularChart(
                      legend: Legend(isVisible: true, position: LegendPosition.bottom),

                      series: <CircularSeries>[
                    // Render pie chart
                    PieSeries<Customer, String>(

                      dataLabelSettings: DataLabelSettings(isVisible:true),

                      dataSource: listaDados,
                      emptyPointSettings: EmptyPointSettings(
                          mode: EmptyPointMode.average,
                          color: Colors.red,
                          borderColor: Colors.black,
                          borderWidth: 2),
                        sortingOrder: SortingOrder.ascending,
                        sortFieldValueMapper: (Customer sales, _) => sales.nome,

                      xValueMapper: (Customer sales, _) => sales.nome ,
                      yValueMapper: (Customer sales, _) => sales.valor.floorToDouble(),
                      pointColorMapper: (Customer sales, _) => sales.cor,
                      animationDuration: 1000,
                        explode: true,
                        // First segment will be exploded on initial rendering
                        explodeIndex: 1

                    )
                  ]
                  ),
                )
            )
        )
    );
  }
}

  class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
  }