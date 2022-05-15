import 'package:flutter/material.dart';
import 'package:merenda_escolar/models/itens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';

class OrdemFornecedor1 extends StatefulWidget {
  List<PedidoItens> list;
  String nomeFor;
  List<String> dias;
  OrdemFornecedor1(this.list, this.nomeFor, this.dias);

  @override
  _OrdemFornecedor1State createState() => _OrdemFornecedor1State();
}

class _OrdemFornecedor1State extends State<OrdemFornecedor1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BreadCrumb(
        child: _body(),
      ),
    );
  }

  _body() {
    print("itee ${widget.list.toList()}");
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    var tot = widget.list.map((e) => e.total);
    var tota = tot.reduce((a, b) => a + b);
    var total = formatador.format(tota);
    DateTime crea = DateTime.parse(widget.list.first.created);
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    var jj = widget.list.map((e) => e.nomeescola).toSet().toList();
    print("total de dias ${widget.dias.length}");
    List p =[];

    return Column(
      children: [
        Container(
          height: 50,
          color: Colors.blue,
          child: Row(
                  children: [
                    Container(
                      child: Text('Produto'),
                      width: 300,
                    ),
                    Container(
                      child:
                      Text("Quant."),
                      width: 50,
                    ),
                      Container(
                      child: Expanded(
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: 200,
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemCount: widget.dias.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.redAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 60),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                    Text(
                                        ' dia ${widget.dias[index]}'),

                                  ]),
                                ),
                              );
                            }),
                      ),
                    ),

                  ],
                )

        ),
        Expanded(
          child: ListView.builder(
            itemCount: jj.length,
            itemBuilder: (context, index1) {

              var h =
              widget.list.where((e) => e.nomeescola == jj[index1]).toList();



                p.add(h);

              print("PPPPPPPPPPP ${p.length}");


              var largura = MediaQuery.of(context).size.width;

              var altura = MediaQuery.of(context).size.height;

              return Container(
                height: altura,
                child: Column(
                  children: [
                    Text("Escola ${jj[index1]}"),
                    Expanded(
                      child: ListView.builder(
                          itemCount: h.length,
                          itemBuilder: (context, index2) {
                            PedidoItens l = h[index2];

                            return Container(
                              height: 35,
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(l.alias),
                                    width: 300,
                                  ),
                                  Container(
                                    child:
                                        Text(l.quantidade.toStringAsFixed(2)),
                                    width: 50,
                                  ),

                                  Container(
                                    child:
                                    IconButton(onPressed: (){


                                    },icon: Icon(Icons.check),),
                                    width: 50,
                                  ),

                                  Container(
                                    child: Expanded(
                                      child: GridView.builder(
                                          scrollDirection: Axis.horizontal,
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                            mainAxisExtent: 200,
                                            maxCrossAxisExtent: 200,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                          ),
                                          itemCount: widget.dias.length,
                                          itemBuilder: (context, index3) {


                                            return InkWell(
                                              onTap: (){
                                               for( var k in widget.list){
                                                 print('Quant $k - ${l.quantidade /
                                                     widget.dias.length}');
                                               }



                                              },
                                              child: Container(
                                                color: Colors.redAccent,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 60),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text((l.quantidade /
                                                            widget.dias.length)
                                                        .toStringAsFixed(1)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );

  }


}


