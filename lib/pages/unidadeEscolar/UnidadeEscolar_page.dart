
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/unidade_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_add.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_listview.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';


class UnidadeEscolarPage extends StatefulWidget {

  @override
  _UnidadeEscolarPageState createState() => _UnidadeEscolarPageState();
}

class _UnidadeEscolarPageState extends State<UnidadeEscolarPage> {
  Usuario get user => AppModel.get(context).user;
  List<UnidadeEscolar> lista;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<UnidadeBloc>(context, listen: false).fetch(context).then((_) {
      setState(() {
        _isLoading = false;
      });});
  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UnidadeBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
      return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;

    return  Scaffold(
      body: BreadCrumb(
        child:UnidadeEscolarListView(lista),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );
    

  }

  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("UnidadeEscolar",UnidadeEscolarAdd()));
  }


}

