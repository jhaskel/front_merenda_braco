import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_detalhe.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/nav.dart';



class EstoqueMenos extends StatefulWidget {
  @override
  _EstoqueMenosState createState() => _EstoqueMenosState();
}

class _EstoqueMenosState extends State<EstoqueMenos> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  final _bloc = EstoqueBloc();
  List<Estoque> estoques;
  Key key;
  ScrollController _controller = ScrollController();
  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalEstoque = 0;
  double totalLicitado = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;



  @override
  void initState() {
  //  _bloc.fetchMenos(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    return StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os estoques");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Estoque> listProd = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 50,
                      child: Text(
                        'Estoques Não Pedido',
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
                          Text('Estoque'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('Estoque.'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Unid.'),
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
                            onTap: (){
                            _onClickDetalhe(pro);
                            },
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(pro.unidade),
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

    void _onClickDetalhe(Estoque pro) {
    push(
        context,
        EstoqueDetalhe(
          estoque: pro,
        ));
  }

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }
}
