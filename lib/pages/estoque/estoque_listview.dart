import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_api.dart';
import 'package:merenda_escolar/pages/estoque/estoque_detalhe.dart';
import 'package:merenda_escolar/pages/estoque/estoque_edit.dart';


import 'package:merenda_escolar/utils/nav.dart';

class EstoqueListView extends StatefulWidget {
  final List<Estoque> estoque;
  EstoqueListView(this.estoque);

  @override
  _EstoqueListViewState createState() => _EstoqueListViewState();
}

class _EstoqueListViewState extends State<EstoqueListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Estoque> estoque2;
  //controle que define a pagina a ser exibida


  @override
  Widget build(BuildContext context) {
    return _grid(widget.estoque);
  }

  _grid(List<Estoque> estoque) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.estoque.length,
              itemBuilder: (context, index) {
                Estoque c = widget.estoque[index];

                return _cardEstoque(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardEstoque(Estoque c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
        onTap: ()=>_onClickDetalhe(c),
          leading: CircleAvatar(
            backgroundColor: c.isativo ? AppColors.secundaria : AppColors.grey,
            child: Text(i.toString()),
          ),
          title: c.isativo
              ? Text(c.alias)
              : Text(
                  c.alias,
                  style: AppTextStyles.body_noAtive,
                ),

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
        Divider(
        thickness: 1.2,
          color: c.agrofamiliar ? Colors.green : Colors.grey,
        )
      ],
    );
  }

  showExcluir(
    BuildContext context,
    Estoque dados,
  ) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          widget.estoque.removeWhere((element) => element.id == dados.id);
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

  Future<void> _onClickExcuir(Estoque dados) async {
    var dado = dados ?? Estoque();
    dado.id = dados.id;
    await EstoqueApi.delete(context, dado);
  }



  void _onClickEdit(Estoque c) {
    push(
        context,
        EstoqueEdit(
          estoque: c,
        ));
  }

  void _onClickDetalhe(Estoque c) {
    push(
        context,
        EstoqueDetalhe(
          estoque: c,
        ));
  }
}
