
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/pro.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/pdf/produto_mais_pedido.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'dart:async';

class ProdutoMaisPedido extends StatefulWidget {
  @override
  _ProdutoMaisPedidoState createState() => _ProdutoMaisPedidoState();
}

class _ProdutoMaisPedidoState extends State<ProdutoMaisPedido> {
  List<PedidoItens> _allContacts = List<PedidoItens>();
  StreamController<List<PedidoItens>> _contactStream =
  StreamController<List<PedidoItens>>();
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  ScrollController _controller = ScrollController();
  Usuario get user => AppModel.get(context).user;

  final _blocItens = PedidoItensBloc();
  List<PedidoItens> pedidos;
  Key key;

  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalProduto = 0;
  double totalLicitado = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;

  @override
  void initState() {
    _blocItens.fetchMaisPedidos(context, ano).then((value) {
      setState(() {
        for(var x in value){
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _body(),
    );

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

          String nome;
          String unidade;
          double quantidade;
          double total;

          List<PedidoItens> listItens = snapshot.data;
          print('listItens ${listItens}');
          List<Pro> list3 = [];
          for(var x in listItens){
            var tot1 = x.valor;
            var tot2 = tot1* x.tot;
            list3.add(Pro(x.alias,x.unidade,x.tot,tot2));
          }



          return BreadCrumb(
            actions: [
              PrintButton(
                onPressed: () => _onClickAdd(list3),
              )
            ],
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 50,
                      child: Text(
                        'Produtos Mais Pedido',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),


                SizedBox(height: 5,),
                Container(
                  color: Colors.black12,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Produto'),
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
                            return TextError("Não foi possível buscar os dados!");
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<PedidoItens> contacts = snapshot.hasData ? snapshot.data : [];



                          return ListView.builder(
                            controller: _controller,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {

                              PedidoItens pro = contacts[index];
                              var tot1 = pro.valor;
                              var tot2 = tot1* pro.tot;
                              return Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(pro.alias),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        }
                    ),
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

  _onClickAdd(List<Pro> list) {
    print('lisx${list}');
    PagesModel.get(context)
        .push(PageInfo("Imprimir", ProdutoMaisPedidoPdf(key, list)));
  }
  void _onSimpleSearch2Changed(String value) {

    List<PedidoItens> foundContacts = _allContacts
        .where((PedidoItens contact) =>
    contact.alias
        .toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();
    this._contactStream.add(foundContacts);

  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }
}


