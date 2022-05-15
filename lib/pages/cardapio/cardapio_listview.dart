import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_api.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_detalhe.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_edit.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';

import 'package:merenda_escolar/utils/bloc/bloc.dart';
import 'package:merenda_escolar/utils/nav.dart';

class CardapioListView extends StatefulWidget {
  final List<Cardapio> cardapio;
  final List<UnidadeEscolar> listEscolas;

  CardapioListView(this.cardapio, this.listEscolas);

  @override
  _CardapioListViewState createState() => _CardapioListViewState();
}

class _CardapioListViewState extends State<CardapioListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();

  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  List<UnidadeEscolar> get listEscolas => widget.listEscolas;
  List<UnidadeEscolar> get listCardapio => widget.listEscolas;


  int idEscola;

  @override
  void initState() {
    idEscola = listEscolas.first.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _grid(widget.cardapio, listEscolas);
  }

  _grid(List<Cardapio> cardapio, List<UnidadeEscolar> listEscolas) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            setorCardapio(constraints),
          ],
        );
      },
    );
  }

  setorCardapio(BoxConstraints constraints) {
    var largura = constraints.maxWidth;
    var colunas = largura > 600 ? 3 :1;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Scrollbar(
          controller: _controller,
          isAlwaysShown: true,
          child: GridView.builder(
            controller: _controller,
            itemCount: widget.cardapio.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colunas,
                childAspectRatio: 1.5,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
            itemBuilder: (context, index) {
              Cardapio c = widget.cardapio[index];
              return _cardCardapio(c, constraints);
            },
          ),
        ),
      ),
    );
  }

  _cardCardapio(Cardapio c, BoxConstraints constraints) {


      return ListTile(
        title: Text(c.nomedaescola,overflow: TextOverflow.ellipsis,maxLines: 1,),
        subtitle: Container(
             child: Image.network(c.imagem)),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      pop(context);
                      _onClickDetalhe(c);
                    },
                    child: Text("Ver mais...")
                    ),
              ),
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      pop(context);
                      _onClickEdit(c);
                    },
                    child: Text("Editar")
                ),
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
                    child: Text("Excluir")
                ),
              ),
            ),
          ],
        ),
        onTap: () => _onClickDetalhe(c),
      );

  }

  showExcluir(
    BuildContext context,
    Cardapio dados,
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
          widget.cardapio.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.nomedaescola} '),
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

  Future<void> _onClickExcuir(Cardapio dados) async {
    var dado = dados ?? Cardapio();
    dado.id = dados.id;
      await CardapioApi.delete(context, dado);
  }

  Future<void> _onRefreshEscola(int id) async {
    setState(() {
      idEscola = id;
    });
  }

  void _onClickEdit(Cardapio c) {
    push(
        context,
        CardapioEdit(
          cardapio: c,
        ));
  }

  void _onClickDetalhe(Cardapio c) {
     push(
        context,
        CardapioDetalhe(
          cardapio: c,
        ));

  }
}
