import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/produto_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_add.dart';

import 'package:merenda_escolar/pages/produtos/Produto_listview.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';


class ProdutoPage extends StatefulWidget {
  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;
  List<Produto> lista;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<ProdutoBloc>(context, listen: false).fetch(context).then((_) {
      setState(() {
        _isLoading = false;
      });});
  }


  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }
  // List<PedidoItens> itens =[];

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of<ProdutoBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
      return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;
    return  Scaffold(
      body: BreadCrumb(
        child:ProdutoListView(lista),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );

  }


  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("Novo Produto",ProdutoAdd()));
  }


  refresh() {
    iniciaBloc();
  }

}
