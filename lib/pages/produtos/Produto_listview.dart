import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_add.dart';
import 'package:merenda_escolar/pages/produtos/Produto_api.dart';
import 'package:merenda_escolar/pages/produtos/Produto_detalhe.dart';
import 'package:merenda_escolar/pages/produtos/Produto_edit.dart';



import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';

class ProdutoListView extends StatefulWidget {
  final List<Produto> produto;
  ProdutoListView(this.produto);

  @override
  _ProdutoListViewState createState() => _ProdutoListViewState();
}

class _ProdutoListViewState extends State<ProdutoListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Produto> produto2;
  //controle que define a pagina a ser exibida


  @override
  Widget build(BuildContext context) {
    return _grid(widget.produto);
  }

  _grid(List<Produto> produto) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                controller: _controller,
                itemCount: widget.produto.length,
                itemBuilder: (context, index) {
                  Produto c = widget.produto[index];

                  return _cardProduto(c, constraints, index);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _cardProduto(Produto c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
        onTap: ()=>_onClickDetalhe(c),
          leading: CircleAvatar(
            backgroundColor:  AppColors.secundaria,
            child: Text(i.toString()),
          ),
          title:Text(c.alias),

          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        pop(context);
                        _onClickEdit(c);
                      },
                      child: Text("Editar")),
                ),
              ),
              PopupMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        pop(context);
                        showExcluir(context, c);
                      },
                      child: Text("Excluir")),
                ),
              ),
            ],
          ),

        ),

      ],
    );
  }

  showExcluir(
    BuildContext context,
    Produto dados,
  ) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          widget.produto.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.alias} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse registro?'),
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

  Future<void> _onClickExcuir(Produto dados) async {
    var dado = dados ?? Produto();
    dado.id = dados.id;
    await ProdutoApi.delete(context, dado);
  }



  void _onClickEdit(Produto c) {
    push(
        context,
        ProdutoAdd(
          produto: c,
        ));
  }

  void _onClickDetalhe(Produto c) {
    push(
        context,
        ProdutoDetalhe(
          produto: c,
        ));
  }
}
