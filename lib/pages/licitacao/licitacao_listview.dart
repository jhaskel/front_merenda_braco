import 'dart:async';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:merenda_escolar/app_model.dart';

import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_add.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_api.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_detalhe.dart';
import 'package:merenda_escolar/utils/nav.dart';

class LicitacaoListView extends StatefulWidget {
  final List<Licitacao> licitacao;
  LicitacaoListView(this.licitacao);

  @override
  _LicitacaoListViewState createState() => _LicitacaoListViewState();
}

class _LicitacaoListViewState extends State<LicitacaoListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Licitacao> licitacao2;
  //controle que define a pagina a ser exibida


  Map<String,LineIcon> asd = {
   "teste":LineIcon.mouse(),
};

  @override
  Widget build(BuildContext context) {

    return _grid(widget.licitacao);
  }

  _grid(List<Licitacao> licitacao) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.licitacao.length,
              itemBuilder: (context, index) {
                Licitacao c = widget.licitacao[index];
                return _cardLicitacao(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }


  _cardLicitacao(Licitacao c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
          onTap: ()=>_onClickDetalhe(c),

          title: c.isativo
              ? Text(c.alias)
              : Text(
                  c.alias,
                  style: AppTextStyles.body_noAtive,
                ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c.processo),
              getAtivo(c.isativo)
            ],

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
         Divider(thickness: 1,)
      ],
    );
  }

  showExcluir(
    BuildContext context,
    Licitacao dados,
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
          widget.licitacao.removeWhere((element) => element.id == dados.id);
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

  Future<void> _onClickExcuir(Licitacao dados) async {
    var dado = dados ?? Licitacao();
    dado.id = dados.id;
    await LicitacaoApi.delete(context, dado);
  }


  void _onClickEdit(Licitacao c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('Licitação', LicitacaoAdd(licitacao: c,)));

  }
  void _onClickDetalhe(Licitacao c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('${c.processo}', LicitacaoDetalhe(licitacao: c,)));



  }

   getAtivo(bool valor) {
    if(valor){
      return Text("Ativo",style: TextStyle(color: Colors.green),);
    }else{
      return Text("Expirado",style: TextStyle(color: Colors.red),);
    }

  }
}
