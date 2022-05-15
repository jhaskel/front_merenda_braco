import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/nivel_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_listview.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'Nivel_add.dart';

class NivelPage extends StatefulWidget {
  @override
  _NivelPageState createState() => _NivelPageState();
}

class _NivelPageState extends State<NivelPage> {

  Usuario get user => AppModel.get(context).user;

  List<Nivel> lista;
  bool _isLoading = true;
  iniciaBloc() {
    Provider.of<NivelBloc>(context, listen: false).fetch(context).then((_) {
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
    final bloc = Provider.of<NivelBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
      return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;

    return  Scaffold(
      body: BreadCrumb(
        child:NivelListView(lista),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );
  }

  _onClickAdd() {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('Nivel Escolar', NivelAdd()));
  }


}

