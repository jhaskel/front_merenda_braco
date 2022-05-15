import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedido_detalhe.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  Usuario get user => AppModel.get(context).user;

  List<PedidoItens> pedidos;
  List<Pedido> lista;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  double totalPedido = 0;
  var _showProgress = false;

  int index = 0;
  bool _isLoading = true;

  bool online = true;


  iniciaBloc() async {

    if (user.isUnidade()) {
      Provider.of<PedidoBloc>(context, listen: false)
          .fetchEscola(context, user.escola)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      print("IX $index");
      if (index == 0) {
        Provider.of<PedidoBloc>(context, listen: false)
            .fetchCheck(context, false)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        Provider.of<PedidoBloc>(context, listen: false)
            .fetchCheck(context, true)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {


    return !online?Center(child: Text("NNNNNNNNNN"),):BreadCrumb(
        child: Column(
      children: [
        user.isUnidade()
            ? Container()
            : Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                        child: Text(
                          "Novos",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: (index == 0) ? Colors.green : Colors.black26,
                        onPressed: () {
                          setState(() {
                            index = 0;
                            iniciaBloc();
                            _showProgress = true;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        child: Text(
                          "Processados",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: (index == 1) ? Colors.green : Colors.black26,
                        onPressed: () {
                          setState(() {
                            index = 1;
                            iniciaBloc();
                            _showProgress = true;
                          });
                        }),
                  ],
                ),
              ),
        Expanded(child: _body())
      ],
    ));
  }

  _body() {
    final bloc = Provider.of<PedidoBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      lista = bloc.lista;

    _showProgress = false;
    return _admin(lista);
  }

  _admin(List<Pedido> listPedido) {
    if (listPedido.first.licitacao == 3) {}

    return Column(
      children: [
        InkWell(
          onTap: () {
            buildShowSearch(context, listPedido);
          },
          child: Container(
            height: 40,
            child: TextFormField(
              enabled: false,
              decoration: new InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "Buscar...",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
        Expanded(
          child: RawScrollbar(
            controller: _controller,
            isAlwaysShown: true,
            thickness: 10,
            radius: Radius.circular(15),
            thumbColor: Colors.greenAccent,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                  controller: _controller,
                  itemCount: listPedido.length,
                  itemBuilder: (context, index) {
                    Pedido p = listPedido[index];
                    DateTime crea = DateTime.parse(p.createdAt);

                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            _onClickPedido(p);
                          },
                          leading: Container(
                            color:
                                p.licitacao != 2 ? Colors.green : Colors.blue,
                            height: 50,
                            width: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    DateFormat("dd/MM").format(crea),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    DateFormat("yyyy").format(crea),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(p.nomedaescola),
                              Text('R\$  ${formatador.format(p.total)}'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p.id.toString()),
                              Text(
                                p.status,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          trailing: Column(
                            children: [
                              p.status != Status.pedidoRealizado
                                  ? MergeSemantics(
                                      child: CupertinoSwitch(
                                        value: p.ischeck,
                                      ),
                                    )
                                  : PopupMenuButton(
                                      icon: Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () {},
                                                child: Text("Reabrir cart")),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  _onClickPedido(Pedido c) {
    ///alterado para grolandia devido pedido ser feito manual

      PagesModel nav = PagesModel.get(context);
      nav.push(PageInfo(
          "#${c.id}",
          PedidoDetalhe(
            pedido: c,
            user: user,
          )));

  }

  Future<Pedido> buildShowSearch(BuildContext context, List<Pedido> peds) {
    return showSearch(
      context: context,
      delegate: SearchPage<Pedido>(
        onQueryUpdate: (s) => print(s),
        items: peds,
        searchLabel: 'Buscar',
        suggestion: Center(
          child: Text('Digite nome, af status....'),
        ),
        failure: Center(
          child: Text('Nenhum dado encontrado :('),
        ),
        filter: (person) => [
          person.nomedaescola,
          person.id.toString(),
          person.status,
          person.createdAt,
        ],
        builder: (person) => ListTile(
          title: Text(person.nomedaescola),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(person.id.toString()), Text(person.status)],
          ),
          onTap: () {
            _onClickPedido(person);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
