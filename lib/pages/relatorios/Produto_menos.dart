import 'dart:html';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/pdf/produto_menos_pedido.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class ProdutoMenos extends StatefulWidget {
  @override
  _ProdutoMenosState createState() => _ProdutoMenosState();
}

class _ProdutoMenosState extends State<ProdutoMenos> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  Usuario get user => AppModel.get(context).user;

  final _bloc = EstoqueBloc();
  List<Estoque> produtos;
  Key key;
  ScrollController _controller = ScrollController();
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
    _bloc.fetchMenos(context);
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
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os produtos");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Estoque> listProd = snapshot.data;
          print('listPro ${listProd}');


          return BreadCrumb(
            actions: [
              PrintButton(
                onPressed: () => _onClickAdd(listProd),
              )
            ],
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 50,
                      child: Text(
                        'Produtos Não Pedido',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                Center(
                  child: Container(
                    color: Colors.black12,

                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Produto'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [


                                  Text('Estoque.'),
                                  SizedBox( width: 20,),
                                  Text('Unid.'),
                                  SizedBox( width: 20,),
                                  Text('Processo'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: listProd.length,
                      itemBuilder: (context, index) {
                        Estoque pro = listProd[index];
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
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [


                                          Text(pro.quantidade.toString()),
                                          SizedBox( width: 20,),
                                          Text(pro.unidade),
                                          SizedBox(width: 20,),
                                          Text(pro.processo),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider()
                          ],

                        );
                      },
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
    _bloc.dispose();

    super.dispose();
  }

  _onClickAdd(List<Estoque> list) {
    print('lisx${list}');
    PagesModel.get(context)
          .push(PageInfo("Imprimir", ProdutoMenosPedidoPdf(key, list)));
  }
}
