import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_detalhe.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/grafCol2.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class EstoquesPage extends StatefulWidget {
  Estoque produto;
  Licitacao licitacao;

  EstoquesPage(this.produto,this.licitacao);
  @override
  _EstoquesPageState createState() => _EstoquesPageState();
}

class _EstoquesPageState extends State<EstoquesPage> {

  var formatador = NumberFormat("#,##0.00", "pt_BR");
  List<Estoque> listEstoque;
  List<Categoria> listCategorias;
  Usuario get user => AppModel.get(context).user;

  final _bloc = UnidadeEscolarBloc();
  List<UnidadeEscolar> escolas;

  final _blocItens = PedidoItensBloc();
  List<PedidoItens> pedidos;

  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalEstoque = 0;
  double totalLicitado = 0;
  double estoque = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;

  @override
  void initState() {
    _bloc.fetch(context,false);
    _blocItens.fetchEstoques(context, widget.produto.produto,widget.licitacao.id);

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
                     PagesModel.get(context).push(PageInfo("Estoque",LicitacaoDetalhe(licitacao: widget.licitacao,)));
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
        totalLicitado= widget.produto.quantidade;
        var vP = widget.produto.valor;

        //calcula a quantidade de itens
        var quant = listItens.map((e) => e.tot);
        totalEstoque = quant.reduce((a, b) => a + b);

        //calcula o valor total gasto com o produto
        valorTotal = vP*totalEstoque;

        //calcula a quantidade de licitada


        //calcula a quantidade em estoque
        estoque = totalLicitado - totalEstoque;


        var pro1 = listItens.where((e) => e.produto == widget.produto.produto);
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


                   PagesModel.get(context).push(PageInfo("Estoque",LicitacaoDetalhe(licitacao: widget.licitacao,)),replace: true);
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
                          'Gastos com Estoque',
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
                          '${totalEstoque}',
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
