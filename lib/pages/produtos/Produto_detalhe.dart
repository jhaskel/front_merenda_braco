import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:merenda_escolar/utils/bloc/bloc_produto.dart';


class ProdutoDetalhe extends StatefulWidget {
  final Produto produto;
  ProdutoDetalhe({this.produto});

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  Produto get dados => widget.produto;
  bool _showProgress = false;
  bool _isLoading = true;
  int comprado = 0;
  int estoque = 0;

  final _bloc = PedidoItensBloc();

  final BlocProduto blocPro = BlocProvider.getBloc<BlocProduto>();

  var formatador = NumberFormat("#,##0.00", "pt_BR");



  @override
  void initState() {
    _bloc.fetchProduto(context, dados.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(dados);
    return !_showProgress
        ? Scaffold(
            appBar: AppBar(
              title: Text(dados.alias),
              centerTitle: true,
            ),
            body: _body(),
          )
        : CircularProgressIndicator();
  }

  _body() {


    return LayoutBuilder(
      builder: (context, constraints){
        var lar = constraints.maxWidth;
        var alt = constraints.maxHeight;
        return ListView(
          children: [
            Wrap(
              children: [

                SizedBox(width: 20,),
                lar < 800 ? Container(

                width: lar,
                  child: column(),
                ):Container(

                  width: lar-420,
                  height: 400,
                  child: column(),
                )
              ],
            ),
          ],
        );
      },

    );
  }

   column() {
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Produto:', maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              dados.id.toString(),
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Descrição:', maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              dados.nome,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Alias:', maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              dados.alias,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),


                  ],
                );
  }
}

/*

import 'package:flutter/material.dart';

import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';

import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

import 'package:merenda_escolar/pages/pedidoItens/almoxarifadoAd.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/config_page.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/grafCol2.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:intl/intl.dart';


class ProdutoDetalhe extends StatefulWidget {
  Produto produto;
  List<Produto> listProduto;
  List<Categoria> listCategorias;
  ProdutoDetalhe({this.produto,this.listProduto,this.listCategorias});
  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {

  var formatador = NumberFormat("#,##0.00", "pt_BR");

  Usuario get user => AppModel.get(context).user;
  List<Produto> get listProduto=>widget.listProduto;
  List<Categoria> get listCategorias=>widget.listCategorias;
  final _bloc = UnidadeEscolarBloc();
  List<UnidadeEscolar> escolas;

  final _blocItens = PedidoItensBloc();
  List<PedidoItens> pedidos;

  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalProduto = 0;
  double totalLicitado = 0;
  double estoque = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;

  @override
  void initState() {
    _bloc.fetch(context,false);
    _blocItens.fetchProdutos(context, widget.produto.id, ano);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return _list();

  }

  StreamBuilder<List<PedidoItens>> _list() {
    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: TextButton(onPressed: (){
                        */
/*  PagesModel.get(context).push(PageInfo("Produto",ProdutoPage(produto: listProduto,categoria: listCategorias)));*//*

                      }, child: Icon(Icons.arrow_back_ios,size: 30,)),
                    ),
                  ],

                ),

                Center(child: TextError("Esse produto Ainda não foi Pedido!"))
              ],

            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<PedidoItens> listItens = snapshot.data;
          print('listItens ${listItens}');

          List<Customer> list3 = [];

          //calcula o valor total gasto com o produto
          var tot = listItens.map((e) => e.total);
          valorTotal = tot.reduce((a, b) => a + b);

          //calcula a quantidade de itens
          var quant = listItens.map((e) => e.tot);
          totalProduto = quant.reduce((a, b) => a + b);

          //calcula a quantidade de licitada


          //calcula a quantidade em estoque
          estoque = totalLicitado - totalProduto;

          var pro1 = listItens.where((e) => e.produto == widget.produto.id);
          if (pro1.length > 0) {
            int i = 0;
            for (var ite in listItens) {
              list3.add(Customer(ite.nomeescola, ite.tot, Cores.colorList[i]));
              i++;
            }
            return ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: TextButton(onPressed: (){
                        */
/* PagesModel.get(context).push(PageInfo("Produto",ProdutoPage(produto: listProduto,categoria: listCategorias)),replace: true);*//*

                      }, child: Icon(Icons.arrow_back_ios,size: 30,)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: cores[0],
                      width: larg,
                      height: alt,
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'R\$ ${formatador.format(valorTotal)}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Gastos com Produto',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          )),
                    ),
                    Container(
                      color: cores[1],
                      width: larg,
                      height: alt,
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${totalProduto}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Itens Comprado',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          )),
                    ),
                    Container(
                      color: cores[2],
                      width: larg,
                      height: alt,
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${totalLicitado}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Total Licitado',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          )),
                    ),
                    Container(
                      color: cores[3],
                      width: larg,
                      height: alt,
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${estoque}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Estoque',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 400,
                  width: 1000,
                  child: Row(
                    children: [
                      Container(
                        child: Flexible(
                          flex: 1,
                          child: GrafCol2(list3),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return TextError("Esse produto Ainda não foi Pedido!");
          }
        });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _blocItens.dispose();
    super.dispose();
  }
}

*/
