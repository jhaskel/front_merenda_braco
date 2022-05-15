import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/cart_bloc.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/core/bloc/licitacao_bloc.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado_page.dart';
import 'package:merenda_escolar/pages/cart/Cart.dart';
import 'package:merenda_escolar/pages/cart/Cart_api.dart';
import 'package:merenda_escolar/pages/cart/cartPage.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/pedido_page.dart';
import 'package:merenda_escolar/web/menu.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:community_material_icon/community_material_icon.dart';

class PrincipalPage extends StatefulWidget {
  Usuario user;
  PrincipalPage(this.user);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  Usuario get user => widget.user;
  var _isLoading = true;


  iniciaBloc() {
    Provider.of<EstoqueBloc>(context, listen: false)
        .fetchSetor(context, user.setor)
        .then((value) {
      setState(() {
        _isLoading = false;
        print("UUUUU $value");

      });
    });
    Provider.of<CategoriaBloc>(context, listen: false).fetch(context);
    Provider.of<LicitacaoBloc>(context, listen: false).fetch(context);
    Provider.of<PedidoBloc>(context, listen: false).fetch(context);
    Provider.of<EscolaBloc>(context, listen: false).fetch(context);

  }
  Widget imprimirButton() {
    return Row(
      children: [
        MaterialButton(


            child: Padding(
              padding: const EdgeInsets.only(bottom: 12,top: 12),
              child: Text(
                "Pedidos",
                style: AppTextStyles.heading15White,
              ),
            ),
            color: AppColors.button,

            onPressed: () {

              PagesModel.get(context)
                  .push(PageInfo("Pedidos", PedidoPage()));



            }

        ),
        MaterialButton(

            child: Padding(
              padding: const EdgeInsets.only(bottom: 12,top: 12),
              child: Text(
                "Dispensa",
                style: AppTextStyles.heading15White,
              ),
            ),
            color: AppColors.button,

            onPressed: () {

              PagesModel.get(context)
                  .push(PageInfo("Almoxarifado", AlmoxarifadoPage(widget.user)));



            }

        ),
      ],

    );
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    final blocPage = Provider.of<PageBloc>(context);
    print("PAGE ${blocPage.page}");
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(


        body: _body(),
        bottomNavigationBar: largura < 760 ?imprimirButton():null,



    );
  }


  _body() {
    final blocEstoque = Provider.of<EstoqueBloc>(context);


    if (blocEstoque.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (blocEstoque.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else


      return PrincipalListView(blocEstoque.lista, widget.user);
  }
}

class PrincipalListView extends StatefulWidget {
  List<Estoque> listEstoque;
  Usuario user;
  PrincipalListView(this.listEstoque, this.user);

  @override
  State<PrincipalListView> createState() => _PrincipalListViewState();
}

class _PrincipalListViewState extends State<PrincipalListView> {
  int idLicitacao;
  int idCategoria;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  final tQuantidade = TextEditingController();
  List<int> itens = [];
  String page;
  bool _showProgress = false;
  String nomeEscola;

  List<Cart> listCart=[];

  var _isLoading = false;
  iniciaBloc2(int produto) async{
  await  Provider.of<CartBloc>(context, listen: false).fetchQdeProdutoCart(context,produto);
  }

  iniciaBloc() async {
    print("INB");
    Provider.of<CartBloc>(context, listen: false)
        .fetchUnidade(context, widget.user.escola)
        .then((value) {
      setState(() {
        itens.clear();
        listCart = value;
      });
      if(listCart.length>0){
        for (var x in listCart) {
          itens.add(x.produto);
        }
      }
      print("CXD $itens");

    });

  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blocEscola = Provider.of<EscolaBloc>(context);
    var nnomeEscola=blocEscola.lista.where((e) => e.id==widget.user.escola).toList();
    nomeEscola=nnomeEscola.first.alias;
    print("nomeEs $nomeEscola");
    var blocCat = Provider.of<CategoriaBloc>(context);
    var blocLicitacao = Provider.of<LicitacaoBloc>(context);
    print("idLicitacao = ${idLicitacao}");
    var listLicitacao =
        widget.listEstoque.map((e) => e.licitacao).toSet().toList();
    print("listLicitacao = ${listLicitacao}");
    List<int> listCategorias;
    var listLicitacaoFilter;
    List<Licitacao> lici = [];
    List<Categoria> cat = [];
    for (var x in blocLicitacao.lista) {
      if (listLicitacao.contains(x.id)) {
        lici.add(x);
      }
    }
    print("LICXX $lici");

    idCategoria = blocCat.idCategoria;

    if (idLicitacao != null) {
      print("idLic $idLicitacao");
      print("id lic =  ${widget.listEstoque}");

      var busca = widget.listEstoque.where((e) => e.licitacao == idLicitacao);


      listCategorias = busca.map((e) => e.categoria).toSet().toList();

      print("byx $listCategorias");
      for (var x in blocCat.lista) {
        if (listCategorias.contains(x.id)) {
          cat.add(x);
        }
      }
      if(idCategoria==null){
        idCategoria = listCategorias[0];
      }

    }
    print("IDXX $idCategoria");
    print("CATXX $cat");
    if (idCategoria != null) {

      listLicitacaoFilter =
          widget.listEstoque
              .where((e) => e.licitacao == idLicitacao)
              .where((e) => e.categoria == idCategoria)
              .toList();
    }

    return _isLoading?Container(
          color: Color.fromRGBO(0, 0, 0, .35),
      child: Center(child: Text("Loading...",style:TextStyle(fontSize: 40,color: Colors.white))),
    ):Column(
      children: [
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 50,
                      child: IconButton(
                          onPressed: () {

                            if (idLicitacao != null) {
                              setState(() {
                                idLicitacao = null;
                                idCategoria = null;
                                blocCat.setarIdCategoria(null);
                              });
                            }
                          },
                          icon: Icon(CommunityMaterialIcons.arrow_left),)),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: idLicitacao == null
                        ? Text("Selecione um Edital")
                        : Text("Selecione uma Categoria"),
                  ),


                ],
              ),
              itens.isNotEmpty && !_showProgress
                  ? IconButton(
                      onPressed: () {
                         push(context, CartPage(widget.user));
                       // page = AppPages.cart;
                      //  blocPage.setPage(page);
                     //   blocPage.setNameAppBar('Cart');
                      },
                      icon: Icon(Icons.shopping_cart_outlined))
                  : Container()
            ],
          ),
        ),
        idLicitacao == null
            ? Container(
                height: 200,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 200,
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: lici.length,
                  itemBuilder: (context, index) {
                    var c = lici[index];
                    return _edital(c);
                  },
                ),
              )
            : Container(
                height: 200,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 200,
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.length,
                  itemBuilder: (context, index) {
                    var c = cat[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _categorias(c,blocCat),
                    );

                    Text(c.toString());
                  },
                ),
              ),
        idCategoria != null
            ? Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 200,
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 5,
                    childAspectRatio: .5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: listLicitacaoFilter.length,
                  itemBuilder: (context, index) {
                    Estoque c = listLicitacaoFilter[index];
                    return cardEstoque(
                      c,
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  _edital(Licitacao c) {
    return InkWell(
      onTap: () {
        setState(() {
          idLicitacao = c.id;
          print("idLicitacao$idLicitacao");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.0
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(20.0) //                 <--- border radius here
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              c.processo,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(c.edital),
            Text(c.alias,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500),),
            Text('R\$  ${formatador.format(c.valorfinal)}'),
            SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 20,
            ),
            Text("Restam 285 dias"),
          ],
        ),
      ),
    );
  }

  _categorias(Categoria c, CategoriaBloc blocCat) {
    return InkWell(
      onTap: () {
        setState(() {
          blocCat.setarIdCategoria(c.id);
          idCategoria = c.id;

        });
      },
      child: Container(
        decoration: BoxDecoration(

          border: Border.all(
              width: c.id == idCategoria ?3.0:1.0,
            color: c.id == idCategoria ?Colors.blue:Colors.black,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(20.0) //                 <--- border radius here
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Mostrador.icones[c.icone],size: 78,color: Colors.blue,),
            Text(c.nome,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500),),

          ],
        ),
      ),
    );
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: StadiumBorder(), shadowColor: Colors.lime),
        onPressed: () {
          setState(() {
            idCategoria = c.id;
          });
        },
        child: Text(
          c.nome,
          style: TextStyle(color: Colors.indigo),
        ));
  }

  cardEstoque(
    Estoque c,
  ) {

    final bloc = Provider.of<CartBloc>(context);

    print("total ${bloc.total}");

    return InkWell(
      onTap: (){

        showComprar(context, c,bloc);
      },

      hoverColor: Colors.grey,
      child: Card(
        elevation: 10,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  c.alias ?? "",
                ),
              ),
            ),
            c.agrofamiliar
                ? Chip(
                    backgroundColor: Colors.green,
                    label: Text(
                      "AgroFamiliar",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('R\$ ${formatador.format(c.valor)}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      c.unidade ?? "",
                    ),
                  ),
                ],
              ),
            ),
            !itens.contains(c.produto)
                ? MaterialButton(
                    onPressed: () async {

                      showComprar(context, c,bloc);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    color: AppColors.button,
                    hoverColor: AppColors.green,
                    child: Text(
                      'Comprar',
                      style: AppTextStyles.heading15White,
                    ))
                : MaterialButton(
                    onPressed: () {},
                    color: AppColors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Text(
                      'Cart',
                      style: AppTextStyles.heading15White,
                    )),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
  showComprar(BuildContext context,Estoque c,CartBloc bloc,) async {
   // await iniciaBloc2(c.produto);
    print("idEstoque ${c.id}");
    double largura = 300;
    double comprado = 0;
   // double pro = bloc.qdeProdutoCart;

    if(c.comprado!=null ){
      comprado = c.comprado;
    }
    var estoque = c.quantidade-comprado;

    Widget comprarButton = MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Adicionar ao Carrinho",
              style: AppTextStyles.heading15White,
            )
          ],
        ),
      ),
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      onPressed: () async {
        String quant = tQuantidade.text;
        print("quantti $quant");
        int quantidade;
        if (quant != "") {
          quantidade = int.parse(quant);
          if(quantidade > estoque){
            toast(context, "Quantidade máx $estoque");
          }else{
            _onClickSalvar(context, c, bloc);
            setState(() {
              widget.listEstoque.removeWhere((element) => element.id == c.id);
            });
            pop(context);

          }
        }

      },
    );

    //configura o AlertDialog

    AlertDialog alert = AlertDialog(
      title: Container(
        width: largura,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  tQuantidade.clear();
                  pop(context);
                }),
            Container(
                child: Text(
                  c.nomelicitacao,
                  style: AppTextStyles.body11,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                )),

          ],
        ),
      ),
      content: Container(
        width: largura,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text(
                  c.alias,
                  style: AppTextStyles.heading15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: AppColors.primaria,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    c.unidade,
                    style: AppTextStyles.body11White,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Text(
                  'R\$ ${formatador.format(c.valor)}',
                  style: AppTextStyles.body11,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Container(
                    child: Text(
                      'Estoque: ',
                      style: AppTextStyles.body11,
                    ),
                  ),
                  Container(
                    child: Text(
                      estoque.toString(),
                      style: TextStyle(fontSize: 20,color: Colors.blue),
                    ),
                  ),
                ],

              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  autofocus: true,
                  controller: tQuantidade,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantidade'),
                  validator: (value) =>
                  value.isEmpty ? 'Campo precisa ser preenchido' : null,
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: comprarButton,
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Descrição', style: AppTextStyles.bodyTitleBold)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 300,
                  child: Text(
                    c.nomeproduto,
                    style: AppTextStyles.body11,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                  )),
            ),
          ],
        ),
      ),
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          height: 600,
          child: alert,
        );
      },
    );
  }


  Future<void> _onClickSalvar(
      BuildContext context, Estoque c, CartBloc bloc) async {
    print("ITEXX $itens");
    setState(() {
      _showProgress = true;
    });
    print('colocou no car ${c.alias}');

    String quant = tQuantidade.text;
    print("quantti $quant");
    double quantidade = 1;
    double total = quantidade * c.valor;
    if (quant != "") {
      quantidade = double.parse(quant);
      total = quantidade * c.valor;
    }

    Cart cartt;
    var cart = cartt ?? Cart();
    cart.categoria = c.categoria;
    cart.licitacao = c.licitacao;
    cart.produto = c.produto;
    cart.fornecedor = c.fornecedor;
    cart.unidade = c.unidade;
    cart.cod = c.code;
    cart.alias = c.alias;
    cart.escola = widget.user.escola;
    cart.createdAt = DateTime.now().toIso8601String();
    cart.valor = c.valor;
    cart.quantidade = quantidade;
    cart.total = total;
    cart.isagro = c.agrofamiliar;
    cart.licitacao=c.licitacao;
    cart.nomeescola=nomeEscola;
    cart.processo=c.processo;
    cart.idestoque=c.id;

    ApiResponse<bool> response = await CartApi.save(context, cart);
    int idCart = response.id;
    print('idCart$idCart');
    tQuantidade.clear();

    bloc.add(Cart(
      id: idCart,
      alias: c.alias,
      quantidade: quantidade,
      valor: c.valor,
      unidade: c.unidade,
      categoria: c.categoria,
      licitacao: c.licitacao,
      fornecedor: c.fornecedor,
      escola: widget.user.escola,
      cod: c.code,
      idestoque: c.id,
      createdAt: DateTime.now().toIso8601String(),
      total: total,
    ));
    setState(() {
      _showProgress = false;
    });
    iniciaBloc();

  }



}
