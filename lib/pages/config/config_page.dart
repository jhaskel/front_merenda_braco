
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/config_bloc.dart';
import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/pages/config/config_add.dart';
import 'package:merenda_escolar/pages/config/config_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';


class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;
  List<Config> lista;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<ConfigBloc>(context, listen: false).fetch(context).then((_) {
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

    final bloc = Provider.of<ConfigBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
      return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;
    return  Scaffold(
      body: BreadCrumb(
        child:ConfigListView(lista),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );

  }


  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("Novo Config",ConfigAdd()));
  }


  refresh() {
    iniciaBloc();
  }

}
