import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_detalhe.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';

import 'package:merenda_escolar/utils/nav.dart';


class EstoqueMais extends StatefulWidget {
  @override
  _EstoqueMaisState createState() => _EstoqueMaisState();
}

class _EstoqueMaisState extends State<EstoqueMais> {
  List<PedidoItens> _allContacts = [];
  StreamController<List<PedidoItens>> _contactStream =
      StreamController<List<PedidoItens>>();
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  ScrollController _controller = ScrollController();

  final _blocItens = PedidoItensBloc();
  final _blocEstoque = EstoqueBloc();
  List<PedidoItens> pedidos;
  List<Estoque> listEstoques;
  Key key;

  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalEstoque = 0;
  double totalLicitado = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  bool _buscaEstoque = true;

  iniciaBloc(int estoque) {
   Estoque pro;
    _blocEstoque.fetchId(context,estoque).then((value) {
      setState(() {
        print('X2');
        listEstoques = value;
        pro = listEstoques.first;
        _buscaEstoque = false;
      });
    }).then((value) => _onClickDetalhe(pro));
  }

  @override
  void initState() {
    _blocItens.fetchMaisPedidos(context, ano).then((value) {
      setState(() {
        for (var x in value) {
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);
      });
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os itens do pedido");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 50,
                      child: Text(
                        'Estoques Mais Pedido',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),

                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.black12,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estoque'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Quant'),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Unid'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _controller,
                    isAlwaysShown: true,
                    showTrackOnHover: true,
                    thickness: 10,
                    radius: Radius.circular(15),
                    child: StreamBuilder<List<PedidoItens>>(
                        stream: _contactStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return TextError(
                                "Não foi possível buscar os dados!");
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<PedidoItens> contacts =
                              snapshot.hasData ? snapshot.data : [];

                          return ListView.builder(
                            controller: _controller,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              PedidoItens pro = contacts[index];
                              var tot1 = pro.valor;
                              var tot2 = tot1 * pro.tot;
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                    print('X1');
                                    await iniciaBloc(pro.id);
                                      print('X3');
                                  //    !_buscaEstoque??_onClickDetalhe(estoque);
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(pro.alias),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(pro.tot.toString()),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(pro.unidade),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total Gasto'),
                                        Text('R\$ ${formatador.format(tot2)}'),
                                      ],
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _blocItens.dispose();
    _contactStream.close();
    super.dispose();
  }

  void _onSimpleSearch2Changed(String value) {
    List<PedidoItens> foundContacts = _allContacts
        .where((PedidoItens contact) =>
            contact.alias.toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();
    this._contactStream.add(foundContacts);
  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }

  void _onClickDetalhe(Estoque pro) {
    push(
        context,
        EstoqueDetalhe(
          estoque: pro,
        ));
  }
}
