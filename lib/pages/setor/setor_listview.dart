import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/pages/setor/setor_api.dart';
import 'package:merenda_escolar/pages/setor/setor_detalhe.dart';
import 'package:merenda_escolar/pages/setor/setor_edit.dart';
import 'package:merenda_escolar/utils/nav.dart';


class SetorListView extends StatefulWidget {
  final List<Setor> setor;
  SetorListView(this.setor);

  @override
  _SetorListViewState createState() => _SetorListViewState();
}

class _SetorListViewState extends State<SetorListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Setor> setor2;
  //controle que define a pagina a ser exibida

  @override
  Widget build(BuildContext context) {
    return _grid(widget.setor);
  }

  _grid(List<Setor> setor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.setor.length,
              itemBuilder: (context, index) {
                Setor c = widget.setor[index];
                return _cardSetor(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardSetor(Setor c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
          onTap: (){
            _onClickDetalhe(c);
          },
          leading: CircleAvatar(
            backgroundColor: c.isativo ? AppColors.secundaria : AppColors.grey,
            child: Text(i.toString()),
          ),
          title: c.isativo
              ? Text(c.nome)
              : Text(
                  c.nome,
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
          thickness: 1,
        )
      ],
    );
  }

  showExcluir(
    BuildContext context,
    Setor dados,
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
          widget.setor.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.nome} '),
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

  Future<void> _onClickExcuir(Setor dados) async {
    var dado = dados ?? Setor();
    dado.id = dados.id;
    await SetorApi.delete(context, dado);
  }

  void _onClickEdit(Setor c) {
    push(
        context,
        SetorEdit(
          setor: c,
        ));
  }

  void _onClickDetalhe(Setor c) {
    push(
        context,
        SetorDetalhe(
          setor: c,
        ));
  }
}
