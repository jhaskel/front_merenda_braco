import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';

class OrdemFornecedorOr extends StatefulWidget {
  List<PedidoItens> list;
  String nomeFor;
  List<String> dias;
  OrdemFornecedorOr(this.list, this.nomeFor,this.dias );

  @override
  _OrdemFornecedorOrState createState() => _OrdemFornecedorOrState();
}

class _OrdemFornecedorOrState extends State<OrdemFornecedorOr> {
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
    var tota = tot.reduce((a, b) => a+b);
    var total = formatador.format(tota);
    DateTime crea = DateTime.parse(widget.list.first.created);
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    var jj = widget.list.map((e) => e.nomeescola).toSet().toList();
    print("total de dias ${widget.dias.length}");
    List o = [];

  for(var f in widget.dias){
    for(var x in jj){
      var h = widget.list.where((e) => e.nomeescola==x).toList();
      for( var k in h){
        o.add(k);
      }
    }
  }

    print("Lista final  ${o.length}");
    print("Lista final  $o");



return ListView.builder(
  itemCount: widget.dias.length,
  itemBuilder: (context, index){
    return  Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Text("Dia ${widget.dias[index]}"),
          Expanded(
            child: ListView.builder(
              itemCount: jj.length,
              itemBuilder: (context, index) {
                var h = widget.list.where((e) => e.nomeescola==jj[index]).toList();
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Text("Escola ${jj[index]}"),
                      Expanded(
                        child: ListView.builder(
                            itemCount:h.length,
                            itemBuilder: (context,index){
                              PedidoItens l = h[index];
                              return Container(
                                height: 35,

                                child: Column(


                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(l.alias),
                                        Text(l.quantidade.toStringAsFixed(2))
                                      ],
                                    ),
                                    Divider(thickness: 1.2,)

                                  ],



                                ),
                              );
                            }


                        ),
                      ),
                    ],

                  ),
                );
              }
            ),
          ),
        ],

      ),
    );
  },

);





   /* return ListView.builder(
      itemCount: widget.dias.length,
        itemBuilder: (context, index){
         return Container(
           height: 500,
           child: Column(
             children: [
               Container(height:50,child: Text("dia ${widget.dias[index]}")),
               Expanded(
                 child: ListView.builder(
                     itemCount: widget.list.length,
                     itemBuilder: (context, index){
                     var x =widget.list.map((e) => e.nomeescola).toSet().toList();

                    print(x);

                       return Container();
                      *//* return Column(
                         children: [
                           Container(
                            height:50,
                               child: Text('${jj[index]}')
                           ),
                         *//**//*  Container(
                             height:150,
                             child: ListView.builder(
                               itemCount: widget.list.length,
                               itemBuilder: (context,index){


                                   print("escola0 ${widget.list[index].nomeescola}");
                                   print("escola ${jj[index]}");

                                  *//**//**//**//* if(x.nomeescola==jj[index]){
                                     print("dia ${widget.dias[index]}");
                                     print("escola ${jj[index]}");
                                     print("alis ${x.alias} -- quant ${x.quantidade}");
                                   }    *//**//**//**//*


                             //    List<PedidoItens> nova = widget.list.where((e) => e.nomeescola==jj[index]).toList();
                                 print("NOVA00 ");

                          //       print("NOVA $nova");


                               return Container();
                                 return Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text("${widget.list[index].alias}"),
                                   Text("${widget.list[index].quantidade}"),
                                 ],


                               );

                             }),
                           ),*//**//*
                         ],

                       );*//*
                     }
                 ),
               ),
             ],
           )
         );

        return Text('${widget.dias[index]}');
        });*/
/*
    for(var k in widget.dias){
      print("dia $k");
      return Text('dia $k');
    *//*  for(var jh in jj){
        var kk = widget.list.where((element) => element.escola == jh);
        print("finalizaou dia $k");
        return Wrap(children: [
          Text('${kk.first.nomeescola} dia: $k')
        ],);

      }*//*


    }*/


  }

  _kl(String x) {
      Container(height:50,child: Text(x.toString()));

    }


}
