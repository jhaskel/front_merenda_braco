
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/categoria_add.dart';
import 'package:merenda_escolar/pages/categorias/categoria_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';


class CategoriaPage extends StatefulWidget {

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {

  Usuario get user => AppModel.get(context).user;

  List<Categoria> lista;

  bool _isLoading = true;
  iniciaBloc() {
    Provider.of<CategoriaBloc>(context, listen: false).fetch(context).then((_) {
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

    final bloc = Provider.of<CategoriaBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
      return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;
    return  Scaffold(
      body: BreadCrumb(
        child:CategoriaListView(lista),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );
    

  }


  // Adicionar novo carro
  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("Categoria",CategoriaAdd()));
  }


}

