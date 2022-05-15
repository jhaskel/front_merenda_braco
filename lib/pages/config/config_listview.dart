import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/pages/config/config_add.dart';
import 'package:merenda_escolar/pages/config/config_api.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';

class ConfigListView extends StatefulWidget {
  final List<Config> config;
  ConfigListView(this.config);

  @override
  _ConfigListViewState createState() => _ConfigListViewState();
}

class _ConfigListViewState extends State<ConfigListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Config> config2;
  //controle que define a pagina a ser exibida


  @override
  Widget build(BuildContext context) {
    return _grid(widget.config);
  }

  _grid(List<Config> config) {
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
                itemCount: widget.config.length,
                itemBuilder: (context, index) {
                  Config c = widget.config[index];

                  return _cardConfig(c, constraints, index);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _cardConfig(Config c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(

          leading: CircleAvatar(
            backgroundColor:  AppColors.secundaria,
            child: Text(i.toString()),
          ),
          title:Text(c.nomeContato),

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
    Config dados,
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
          widget.config.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.nomeContato} '),
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

  Future<void> _onClickExcuir(Config dados) async {
    var dado = dados ?? Config();
    dado.id = dados.id;
    await ConfigApi.delete(context, dado);
  }



  void _onClickEdit(Config c) {
    push(
        context,
        ConfigAdd(
          config: c,
        ));
  }


}
