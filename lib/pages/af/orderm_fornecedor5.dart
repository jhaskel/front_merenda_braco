import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/bloc/itens_bloc.dart';
import 'package:merenda_escolar/models/itens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';

class OrdemFornecedor5 extends StatefulWidget {
  List<PedidoItens> list;
  String nomeFor;
  List<String> dias;
  OrdemFornecedor5(this.list, this.nomeFor, this.dias);

  @override
  _OrdemFornecedor5State createState() => _OrdemFornecedor5State();
}

class _OrdemFornecedor5State extends State<OrdemFornecedor5> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItensBloc>(context, listen: false);
    final bloc = Provider.of<ItensBloc>(context, listen: false);
    bloc.listaFor.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ItensBloc>(context);

    return Scaffold(
      body: BreadCrumb(
        child: _body(bloc),
        actions: [
          IconButton(
              onPressed: () {
                print('apagando');
                bloc.listaFor.clear();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
    );
  }

  _body(ItensBloc bloc) {
    bloc.clearr();
    bloc.listaFor.clear();
    print("itee ${bloc.listaFor.length}");
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    var tot = widget.list.map((e) => e.total);
    var tota = tot.reduce((a, b) => a + b);
    var total = formatador.format(tota);
    DateTime crea = DateTime.parse(widget.list.first.created);
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    var jj = widget.list.map((e) => e.nomeescola).toSet().toList();
    print("total de dias ${widget.dias.length}");
    List<PedidoItens> o = [];
    var quant = widget.dias.length;
    print("quant $quant");

    Itens it;

    int i = 0;
  /*  for (var j in widget.dias) {
      for (var t in widget.list) {
        it = Itens(
            id: i,
            cod: t.cod,
            produto: t.alias,
            uni: t.unidade,
            qde: t.quantidade,
            valor: t.valor,
            total: t.total,
            entrega: j,
            escola: t.nomeescola,
            nivel: t.nivel);
        bloc.addFor(it);
      }
      i++;
    }*/
    print("LIST FINAL ${bloc.listaFor}");

   /* return ListView.builder(
      itemCount: widget.dias.length,
      itemBuilder: (context, index) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text("Dia ${widget.dias[index]}"),
              Expanded(
                child: ListView.builder(
                    itemCount: jj.length,
                    itemBuilder: (context, index) {
                      var h = bloc.listaFor
                          .where((e) => e.escola == jj[index]).toList();
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Text("Escola ${jj[index]}"),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: h.length,
                                  itemBuilder: (context, index) {
                                    Itens l = h[index];
                                    return Container(
                                      height: 35,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(l.produto),
                                                Text(
                                                    '${(l.qde).toStringAsFixed(2)}')
                                              ],
                                            ),
                                            onTap: () {
                                              int indexx =
                                                  bloc.listaFor.indexOf(l);
                                     //         bloc.alteraQuant(indexx);

                                              alert(context, '$indexx');
                                            },
                                          ),
                                          Divider(
                                            thickness: 1.2,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
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
    );*/
  }
}
