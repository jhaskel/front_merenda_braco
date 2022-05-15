import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/cart_bloc.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/core/bloc/unidade_bloc.dart';
import 'package:merenda_escolar/pages/cart/Cart.dart';
import 'package:merenda_escolar/pages/cart/Cart_api.dart';
import 'package:merenda_escolar/pages/compras/Compras.dart';
import 'package:merenda_escolar/pages/compras/compras_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd_api.dart';
import 'package:merenda_escolar/pages/pedido/pedido_page.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:intl/intl.dart';

import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';

class CartPage extends StatefulWidget {
  final Usuario user;

  CartPage(this.user);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  bool _showProgress = false;
  Usuario get user => widget.user;
  List<Cart> listCart;

  int _quant = 0;
  int step;
  int currentStep = 0;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<CartBloc>(context, listen: false)
        .fetchUnidade(context, user.escola)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.user.nome ${widget.user.nome}");
    final bloc = Provider.of<CartBloc>(context);
    final blocx = Provider.of<CartBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Carrinho Vazio',style: TextStyle(color: Colors.green,fontSize: 40),),

          ),
          AppButton(
            "Ir para compras",
            onPressed: _onClickHome,
            showProgress: _showProgress,
          ),
        ],

      );
    } else
      listCart = bloc.lista;

    step = listCart.length;
    print("LIST2 ${listCart}");
    return Scaffold(
      appBar: AppBar(title: Text("Carrinho de Compras"),
        actions: [
          Text(
            'Valor do pedido R\$ ${formatador.format(blocx.total)} ',
            style: AppTextStyles.bodyWhite20,
            textAlign: TextAlign.center,
          )
        ],
      
      ),
        body: _body(blocx),
        
        floatingActionButton: Row(
          children: [
            Spacer(),
            !_showProgress
                ? FloatingActionButton.extended(
                    backgroundColor: AppColors.primaria,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _onClickSalvar(context);
                    },
                    icon: Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Finalizar Compra',
                      style: AppTextStyles.heading15White,
                    ),
                  )
                : Container(),
            SizedBox(
              width: 5,
            ),
            !_showProgress
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      pop(context);
                    },
                    icon: Icon(
                      Icons.shopping_basket_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Continuar Comprando',
                      style: AppTextStyles.heading15White,
                    ),
                  )
                : Container()
          ],
        ));
  }

  _body(CartBloc blocx) {
    final blocPedido = Provider.of<PedidoBloc>(context);
    final blocEscola = Provider.of<EscolaBloc>(context);
    double altura = MediaQuery.of(context).size.height;
    
    _quant = blocPedido.itens;

    return Stack(
      children: [
        Column(
          children: [
            !_isLoading
                ? Container(
                    height: altura - 150,
                    child: ListView.builder(
                        itemCount: listCart.length,
                        itemBuilder: (context, index) {
                          Cart c = listCart[index];
                          return Column(
                            children: [
                              ListTile(
                                  title: Row(children: [
                                    Flexible(
                                      flex: 8,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        c.alias,
                                        style: AppTextStyles.heading15,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "R\$ ${formatador.format(c.valor)}  /  ${c.unidade}",
                                        style: AppTextStyles.heading15,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: InkWell(
                                                    onTap: () async {
                                                      decrement(c);
                                                    },
                                                    child: Icon(Icons
                                                        .indeterminate_check_box))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: Text("${c.quantidade}",
                                                    style: AppTextStyles
                                                        .heading15)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: InkWell(
                                                    onTap: () async {
                                                      increment(c);
                                                    },
                                                    child:
                                                        Icon(Icons.add_box))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "R\$ ${formatador.format(c.quantidade * c.valor)} ",
                                        style: AppTextStyles.heading15,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ]),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showExcluir(context, c,blocx);
                                    },
                                    icon: Icon(Icons.delete),
                                  )),
                              Divider(
                                height: 1,
                              )
                            ],
                          );
                        }),
                  )
                : CircularProgressIndicator(),
            Column(
              children: [
                Container(
                  color: AppColors.button,
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Text(
                    'Valor do pedido R\$ ${formatador.format(blocx.total)} ',
                    style: AppTextStyles.bodyWhite20,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        _showProgress
            ? Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Aguarde....',
                        style: AppTextStyles.heading40White,
                      ),
                      CircularStepProgressIndicator(
                        totalSteps: step,
                        currentStep: currentStep,
                        stepSize: 10,
                        selectedColor: AppColors.secundaria,
                        unselectedColor: AppColors.grey,
                        padding: 0,
                        width: 150,
                        height: 150,
                        selectedStepSize: 15,
                        roundedCap: (_, __) => true,
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  showExcluir(BuildContext context, Cart c, CartBloc blocx) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(
      child: Text("Excluir"),
      onPressed: () async {
        blocx.remove(c);
       /* setState(() {
          listCart.removeWhere((element) => element.id == c.id);
        });*/
        _onClickExcluir(c);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${c.alias} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse ítem?'),
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

  increment(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    blocx.increment(c);
    var quant = c.quantidade + 1;
    var total = quant * c.valor;
    // Cria o usuario
    var carr = c ?? Cart();
    carr.id = c.id;
    carr.quantidade = quant;
    carr.total = total;
    print("total${total}");
    await CartApi.update(context, carr);
  }

  decrement(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    if (c.quantidade > 1) {
      blocx.decrement(c);

      var quant = c.quantidade - 1;
      var total = quant * c.valor;
      // Cria o usuario
      var carr = c ?? Cart();
      carr.quantidade = quant;
      carr.total = total;
      print("total${total}");
      await CartApi.update(context, carr);
    }
  }

  Future<void> _onClickExcluir(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    blocx.remove(c);
    print('excluindo');
    var carr = c ?? Cart();
    carr.id = c.id;
    await CartApi.delete(context, carr);
    //iniciaBloc();
  }

  _onClickSalvar(BuildContext context) async {
    Compras itens;
    final blocx = Provider.of<CartBloc>(context, listen: false);
    final blocEscola = Provider.of<EscolaBloc>(context, listen: false);

    var niv = blocEscola.lista.where((e) => e.id==user.escola);
    var nv = niv.first.nivelescolar;
    final blocPedido = Provider.of<PedidoBloc>(context, listen: false);
     var licitacao =listCart.first.licitacao;
    setState(() {
      _showProgress = true;
    });

    var hoje = DateTime.now().toIso8601String();
    var mes = DateTime.now().month;

    //cria o pedido
    PedidoAdd pedido;
    setState(() {
      _showProgress = true;
    });

    var ped = pedido ?? PedidoAdd();
    ped.escola = user.escola;
    ped.status = Status.pedidoRealizado;
    ped.isativo = true;
    ped.createdAt = hoje;
    ped.modifiedAt = hoje;
    ped.isaf = false;
    ped.total = blocx.total;
    ped.ischeck = false;
    ped.user = user.nome;
    ped.licitacao = licitacao;

    ApiResponse<bool> response =
        (await PedidoAddApi.save(context, ped)) as ApiResponse<bool>;
    var id = response.id;
    if (response.ok) {
      blocPedido.addQuant(1);

      print('quantTT ${listCart.length}');

      for (var c in listCart) {
        print('PRODIDCART ${c.id}');
        var pedi = itens ?? Compras();
        pedi.setor = widget.user.setor;
        pedi.escola = c.escola;
        pedi.produto = c.produto;
        pedi.cod = c.cod;
        pedi.alias = c.alias;
        pedi.categoria = c.categoria;
        pedi.fornecedor = c.fornecedor;
        pedi.unidade = c.unidade;
        pedi.nivel = nv;
        pedi.ano = DateTime.now().year;
        pedi.af = 0;
        pedi.pedido = id;
        pedi.created = hoje;
        pedi.nomeescola = c.nomeescola;
        pedi.quantidade = c.quantidade;
        pedi.valor = c.valor;
        pedi.total = c.total;
        pedi.isagro = c.isagro;
        pedi.status = Status.pedidoRealizado;
        pedi.mes = getMes(mes);
        pedi.isativo = true;
        pedi.licitacao = c.licitacao;
        pedi.obs = "p";
        pedi.ischeck = false;
        pedi.idestoque = c.idestoque;
        pedi.processo = c.processo;
        await ComprasApi.save(context, pedi);
        print('excluindo ${c.id}');
        var carr = c ?? Cart();
        carr.id = c.id;
        setState(() {
          currentStep++;
        });
        CartApi.delete(context, carr);
      }

      blocx.removeAll();
    } else {
      alert(context, response.msg);
    }

    if (response.ok) {
      setState(() {
        showOrderPlace(context, id);
      });
    }

    setState(() {
      _showProgress = false;
    });
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo("pedidos", PedidoPage()),replace: true);


  }

  String getMes(int mes) {
    return Meses.meses[mes];
  }

  showOrderPlace(BuildContext context, int id) {
    final bloc = Provider.of<CartBloc>(context,listen: false);

    Widget continuaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        bloc.limparCart();
        pop(context);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        width: 300,
        height: 650,
        child: Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/order_place.png',
                  height: 350,
                ),
                Text('Pedido Realizado', style: AppTextStyles.bodyLightGrey20),
                Text('Utilize o número abaixo',
                    style: AppTextStyles.bodyLightGrey20),
                Text('#$id', style: AppTextStyles.heading40),
              ],
            )),
      ),
      actions: [

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

  _onClickHome() {
    print("ir");
    pop(context);

  }
}
