import 'dart:html';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/cart/Cart.dart';
import 'package:merenda_escolar/pages/cart/cartPage.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_bloc.dart';
import 'package:merenda_escolar/pages/compras/Compras.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_bloc.dart';

import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedido_api.dart';
import 'package:merenda_escolar/pages/pedido/pedido_bloc.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';

import 'package:merenda_escolar/pages/compras/compras_api.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_bloc.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/bloc/bloc.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/utils/web_utils.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ComprasListView extends StatelessWidget {
  int temCart;
  List<Produto> listProdutos;

  ComprasListView(this.temCart,this.listProdutos);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*

class ComprasListView extends StatefulWidget {
  int temCart;
  List<Produto> listProdutos;

  ComprasListView(this.temCart,this.listProdutos);

  @override
  _ComprasListViewState createState() => _ComprasListViewState();
}

class _ComprasListViewState extends State<ComprasListView> {

  List<Produto> _allContacts = [];
  StreamController<List<Produto>> _contactStream =
  StreamController<List<Produto>>();

  Usuario get user => AppModel.get(context).user;
  bool comprado = false;
  Color cor = Colors.green;
  Color cor2 = Colors.yellow[500];
  bool excluir = false;
  Cart cart;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  bool verifica = false;
  final tQuantidade = TextEditingController();
  final tObs = TextEditingController();
  int _itens = 0;
  int codePedido;
  bool _showProgress = false;
  int idCategoria = 0;
  int idProduto;

  final _blocCategoria = CategoriaBloc();
  List<Categoria> categorias;

  final _bloc = ProdutoBloc();
  List<Produto> produtos;


  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;

  final _blocPedido = PedidoBloc();
  List<Pedido> pedidos;

  final _blocNivel = NivelBloc();
  List<Nivel> niveis;


  final _blocEscolas = UnidadeEscolarBloc();
  List<UnidadeEscolar> escolas;

  final BlocController bloc = BlocProvider.getBloc<BlocController>();
  int total = 0;

  int temCart;
  int ultimoId = 0;
  int idPedido = 0;
  int quantCart = 0;
  String nomeNivel;
  String nomeescola;
  String nomenivel;
  int idnivel;
  int idescola;
  int nivel;
  int nivelescola;
  double estoque;

  Future<int> getQuantCart() async {
    print('getTemCart');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/cart/${user.escola}';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  Future<int> getTemCart() async {
    print('getTemCart');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/temcart/${user.escola}';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  Future<int> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/cart';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  Future<int> getTemCart1() async {
    print('getTemCart1');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/temcart1/${user.escola}';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  int ano = DateTime.now().year;
  Future<int> getUltimoId() async {
    print('getUltimoId');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/ultimoid';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    print('getUltimoId ${json.decode(response.body)}');
    return (json.decode(response.body));
  }


  Future<double> getVerificaEstoque(int id) async {
    print('getVerificaEstoque');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/estoque/$id';
    var response = await http.get(url, headers: headers);
    if(response.statusCode !=500){
      print(json.decode(response.body));
      print('getVerificaEstoque2 ${json.decode(response.body)}');
      return (json.decode(response.body));
    }else {
      return 0;
    }


  }


  _verificaQuantCart() {
    getQuantCart().then((int) async {
      setState(() {
        quantCart = int;
        _itens = quantCart;
      });
    });
  }

  _verificaTemCart1() {
    getTemCart1().then((int) {
      setState(() {
        idPedido = int;
      });
    });
  }

  _verificaUltimoId() async {
    await getUltimoId().then((int) {
      setState(() {
        ultimoId = int;
      });
    });
  }

  @override
  void initState()  {
    _blocEscolas.fetchId(context, user.escola).then((value) {
     setState(() {
       escolas = value;
       UnidadeEscolar esc = escolas.first;
       nomeescola = esc.alias;
       nivelescola = esc.nivelescolar;
       idescola = esc.id;
       if(nomeescola != null){
           _blocNivel.fetchId(context, nivelescola).then((value) {
             setState(() {
               niveis = value;
               Nivel niv = niveis.first;
               idnivel = niv.id;
               nomenivel = niv.nome;
             });
           });
       }
     });

    });
    _verificaQuantCart();
    temCart = widget.temCart;
    if (temCart > 0) {
      _verificaTemCart1();
    }

    _pegaTotal();
    _blocCategoria.fetchAtivo(context);
    _bloc.fetchEscola(context, user.escola).then((value) {
      setState(() {
        for(var x in value){
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);
        print('ORD ${_allContacts} ');

      });
    });

    super.initState();
  }



  @override
  void didChangeDependencies() {
    _blocNivel.fetch(context).then((value) {
      setState(() {
        niveis = value;
        print('nx ${value}');
        for(var gh in value){
          if(gh.id == nivel){
            nomeNivel = gh.nome;
          }
        }
      });
    });
  }

  void _pegaTotal() {
    getTotal().then((int) {
      setState(() {
        total = int;
        bloc.inCounter.add(total);
      });
    });
  }

  @override
  void dispose() {
    _blocCategoria.dispose();
    _bloc.dispose();
    _blocItens.dispose();
    _blocPedido.dispose();
    _blocNivel.dispose();
    _blocEscolas.dispose();
    _contactStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(nomeescola!=null){
      print('XX1${nomeNivel}');
      print('XX2${nivelescola}');
      print('XX3${nomeescola}');
      print('XX4${idescola}');
    }
    print('QQ${_itens}');
    if (temCart > 0) {
      _verificaTemCart1();
    }
    print('tem cart vale${temCart}...');
    print('pedidoID${ultimoId}');
    print('TT${widget.temCart}');
    return _grid();
  }

  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 6 : 3;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid() {
    return Container(
      child: StreamBuilder(
          stream: _blocCategoria.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return TextError("Não foi possível buscar as categorias");
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Categoria> listCategorias = snapshot.data;
            print('Lx$listCategorias');
            // categ = tes.toSet().toList();
            if (listCategorias.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextError("Não foram encontrados nenhum registro!"),
                  ],
                ),
              );
            }
            print('X1');
            return StreamBuilder(
                stream: _bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return TextError(
                        "Não foi possível buscar os itens no carrinho");
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Produto> listProdutos = snapshot.data;

                  var listFilter = listProdutos
                      .where((e) => e.categoria == idCategoria && e.disponivel==true)
                      .toList();
                  if (idCategoria == 0) {
                    listFilter = listProdutos.where((e) => e.disponivel==true).toList();
                  }
                  print('idCategoria ${idCategoria}');

                  if (listProdutos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextError("Não foram encontrados nenhum registro!"),
                        ],
                      ),
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = _columns(constraints);
                      return Column(
                        children: [
                          _itens > 0
                              ? Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _shoppingCartBadge(idPedido,listProdutos),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.remove_shopping_cart_rounded),
                                    ],
                                  ),
                                ),
                          Container(

                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listCategorias.length,
                              itemBuilder: (context, index) {
                                Categoria c = listCategorias[index];
                                return Center(
                                  child: InkWell(
                                      onTap: () => _onRefreshCategoria(
                                          c.id, listCategorias),
                                      child: (c.id == idCategoria)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(15),
                                              child: Chip(
                                                label: Text(c.nome,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                backgroundColor: Colors.green,
                                              )


                                            )
                                          : Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Chip(
                                        label: Text(c.nome,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        backgroundColor: Colors.grey,
                                      ),
                                          )
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 20),
                            child: Container(
                              height: 50,
                              child: AppBarTextField(
                                backgroundColor: Colors.transparent,
                                title: Text("Buscar...."),
                                onBackPressed: _onRestoreAllData,
                                onClearPressed: _onRestoreAllData,
                                onChanged: _onSimpleSearch2Changed,
                                autofocus: true,
                                elevation: 0,
                                clearBtnIcon: Icon(Icons.clear,color: Colors.black87,),
                              ),
                            ),
                          ),
                          StreamBuilder<List<Produto>>(
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
                                List<Produto> contacts = snapshot.hasData ? snapshot.data : [];

                                var listFilter = contacts
                                    .where((e) => e.categoria == idCategoria)
                                    .toList();
                                if (idCategoria == 0) {
                                  listFilter = contacts;
                                }


                              return Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      childAspectRatio: .7,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemCount: listFilter.length,
                                    itemBuilder: (context, index) {
                                      Produto c = listFilter[index];
                                      return LayoutBuilder(
                                        builder: (context, constraints) {
                                          double font = constraints.maxWidth * 0.06;

                                          return InkWell(
                                            onTap: () {
                                              c.disponivel?showComprar(context, c, listFilter):alert(context,"Indisponivel");
                                            },
                                            child: Card(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Center(
                                                      child: c.image == null || c.image == ''
                                                          ? Image.asset(
                                                              'assets/imgs/sem_imagem.png',
                                                              height: 90,
                                                            )
                                                          : Image.network(
                                                              c.image,
                                                              height: 90,
                                                            ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          child: text(
                                                              'R\$ ${formatador.format(c.valor)}' ??
                                                                  "",
                                                              fontSize:
                                                                  fontSize(font),
                                                              maxLines: 1,
                                                              ellipsis: true,
                                                              color: Colors.green,
                                                              bold: true),
                                                        ),
                                                        Container(
                                                          child: text(
                                                            c.unidade ?? "",
                                                            fontSize:
                                                                fontSize(font),
                                                            maxLines: 1,
                                                            ellipsis: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Center(
                                                      child: text(c.alias ?? "",
                                                          fontSize: fontSize(font),
                                                          maxLines: 1,
                                                          ellipsis: true,
                                                          bold: true,
                                                          color: Colors.black87),
                                                    ),
                                                  ),
                                                  c.agrofamiliar
                                                      ? Chip(
                                                          labelPadding:
                                                              EdgeInsets.all(2.0),
                                                          label: Text(
                                                            'Agric. Familiar',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.green[700],
                                                          elevation: 6.0,
                                                          shadowColor:
                                                              Colors.grey[60],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          ),
                        ],
                      );
                    },
                  );
                });
          }),
    );
  }

  _cardCompras(
    Produto c,
    List<Produto> carrto,
  ) {
    return Container();
  }

  _onClickCompras(Produto c) {
    PagesModel nav = PagesModel.get(context);
    //    nav.push(PageInfo(c.nome, ComprasDetalhe(carrto: c)));
  }

  showComprar(BuildContext context, Produto c, List<Produto> carrto) {

    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
        setState(() {
          estoque = 0;
        });
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Adicionar no Carrinho"),
      onPressed: () async {
        await _refresh(c.id);
        _onClickSalvar(context, c);

        pop(context);
        setState(() {
          estoque = 0;
        });
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      
      title: Text('${c.alias} ' ),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: TextFormField(
                controller: tQuantidade,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: 'Quantidade'),
                validator: (value) => value.isEmpty ? 'Campo precisa ser preenchido':null,
              )



            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: AppTextField(
                label: "Obs",
                controller: tObs,
                keyboardType: TextInputType.text,
                required: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onClickSalvar(BuildContext context, Produto c) async {
    print('tem cart vale${temCart}...');
    print('verificando...');
    print('verificou e retornou ${temCart}...');
    String quant = tQuantidade.text;
    double quantidade;
    quantidade = double.parse(quant);
    var comprado;
    var estoque;
    var resta;

    await getVerificaEstoque(c.id).then((value) async {
      if(value != null){
        comprado = value ;
        print('Z1 ${comprado}');
        resta = c.quantidade -comprado - quantidade;
        estoque = c.quantidade -comprado ;
        print('EST ${estoque}');
        print('RES ${resta}');
        if(estoque >= quantidade && resta >=0){
           if (temCart == 0) {
      print('verificando...');
      await _verificaUltimoId();
      print('verificou e retoronou ${ultimoId}...');
      setState(() {
        temCart = 1;
        codePedido = ultimoId + 1;
        print('SIM ${ultimoId}');
        _onCadastraPedido(ultimoId);
      });
    } else {
      await _verificaTemCart1();
      setState(() {
        codePedido = idPedido;
      });
      print('NAO${ultimoId}');
    }

    _itens++;
    setState(() {
      _showProgress = true;
    });

    var hoje = DateTime.now().toIso8601String();
    var mes = DateTime.now().month;
    String quant = tQuantidade.text;
    double quantidade;
    if (quant.contains(',')) {
      quant = quant.replaceAll(".", "");
      quant = quant.replaceAll(",", ".");
      quantidade = double.parse(quant);
    } else {
      quantidade = double.parse(quant);
    }
    var total1 = quantidade * c.valor;
    Compras itens;
    await _pegaTotal();
    bloc.inCounter.add(total);
    var mess = await _getMes(mes);
    print('mesx$mess');
    var pedi = itens ?? Compras();
    pedi.pedido = codePedido.toString();
    pedi.produto = c.id;
    pedi.categoria = c.categoria;
    pedi.fornecedor = c.fornecedor;
    pedi.nivel = nivelescola;
    pedi.escola = user.escola;
    pedi.alias = c.alias;
    pedi.obs = tObs.text;
    pedi.quantidade = quantidade;
    pedi.valor = c.valor;
    pedi.total = total1;
    pedi.created = hoje;
    pedi.ano = DateTime.now().year;
    pedi.unidade = c.unidade;
    pedi.nomeescola = nomeescola;
    pedi.nomenivel = nomenivel;
    pedi.isagro = c.agrofamiliar;
    pedi.status = Status.pedidoRealizado;
    pedi.mes = mess;
    pedi.cod = c.code;
    pedi.ativo = true;
    pedi.processo =c.processo;
    pedi.af = 0;
    ApiResponse<bool> response = await ComprasApi.save(context, pedi);

    if (response.ok) {
      setState(() {
        _verificaQuantCart();
        tQuantidade.clear();
        tObs.clear();
        _bloc.fetchEscola(context, user.escola).then((value) {
          setState(() {
            _allContacts.clear();
            for(var x in value){

              _allContacts.add(x);
            }
            _contactStream.add(_allContacts);

          });
        });
      });

      toast(context, 'Produto Adicionado no Carrinho!');
    }

    setState(() {
      _showProgress = false;
    });


        }else if(estoque >0 && resta < 0){
          alert(context,''
              'Diminua a quantidade para  $estoque');
          tQuantidade.clear();
        }else{
          alert(context,''
              'Produto em falta!  ${c.quantidade} - $estoque');
          tQuantidade.clear();
        }

      }else{
        alert(context,''
       'zerado ${value}');
      }

    });

     }

  Future<void> _onRefreshCategoria(int id, List<Categoria> listCategorias) {
    setState(() {
      idCategoria = id;
    });
  }

  _refresh(int id) {
    setState(() {
      excluir = true;
      idProduto = id;
    });
  }

  Widget sidebar() {
    return new Align(
      alignment: FractionalOffset.centerRight,
      child: new Container(
        child: new Column(
          children: <Widget>[
            new Icon(Icons.navigate_next),
            new Icon(Icons.close),
            new Text("More items..")
          ],
        ),
        color: Colors.blueGrey,
        height: 700.0,
        width: 200.0,
      ),
    );
  }

  Widget _shoppingCartBadge(int idPedido, List<Produto> listProdutos) {
    return InkWell(
      onTap: () {
        PagesModel.get(context).push(PageInfo("Cart", CartPage(user,idPedido,listProdutos)));
      },
      child: Badge(
        position: BadgePosition.topEnd(top: 0, end: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          _itens.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    );
  }

  void _onCadastraPedido(int ultimoId) async {
    Pedido pedido;
    setState(() {
      _showProgress = true;
    });
    var code = ultimoId + 1;
    var hoje = DateTime.now().toIso8601String();
    var ped = pedido ?? Pedido();
    ped.code = code.toString();
    ped.comprador = user.id;
    ped.escola = user.escola;
    ped.nomeescola = nomeescola;
    ped.nivel = nivelescola;
    ped.status = Status.comprando;
    ped.ativo = true;
    ped.created = hoje;
    ped.isaf = false;
    ped.ischeck = false;
    ped.iscart = true;
    ped.total = 0.0;
    await PedidoApi.save(context, ped);
  }

  String _getMes(int mes) {
    switch (mes) {
      case 1:
        return "JAN";
      case 2:
        return "FEV";
      case 3:
        return "MAR";
      case 4:
        return "ABR";
      case 5:
        return "MAI";
      case 6:
        return "JUN";
      case 7:
        return "JUL";
      case 8:
        return "AGO";
      case 9:
        return "SET";
      case 10:
        return "OUT";
      case 11:
        return "NOV";
      case 12:
        return "DEZ";
    }
  }
  void _onSimpleSearch2Changed(String value) {
    List<Produto> foundContacts = _allContacts
        .where((Produto contact) =>
    contact.nome
        .toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();
    this._contactStream.add(foundContacts);
  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }
}
*/
