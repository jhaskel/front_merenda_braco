import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_add.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';


class FornecedorPage extends StatefulWidget {

  @override
  _FornecedorPageState createState() => _FornecedorPageState();
}

class _FornecedorPageState extends State<FornecedorPage> {

  Usuario get user =>
      AppModel
          .get(context)
          .user;

  List<Fornecedor> lista;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<FornecedorBloc>(context, listen: false).fetch(context).then((
        _) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  void initState() {
    iniciaBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FornecedorBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(child: Text('Sem registros!'),);
    } else
      lista = bloc.lista;

    return Scaffold(
      body: BreadCrumb(
        child: FornecedorListView(lista),
        actions: [
          AddButton(
            onPressed: () => _onClickAdd(),
          )
        ],
      ),
    );
  }


  _onClickAdd() {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('Nivel Escolar', FornecedorAdd()));
  }
}





