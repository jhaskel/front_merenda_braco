
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:provider/provider.dart';

class EstoquePage extends StatefulWidget {
  @override
  _EstoquePageState createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  List<Estoque> estoques;
  bool _isLoading = true;

  iniciaBloc() {
    print("setorx ${user.setor}");
    Provider.of<EstoqueBloc>(context, listen: false)
        .fetchSetor(context, user.setor)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print("IBB");
    iniciaBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Novo Estoque',
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
      body: _body(),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Container(),
      ),
    );
  }


  _body() {
    final bloc = Provider.of<EstoqueBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      estoques = bloc.lista;
    print("ESTX $estoques");
    return EstoqueListView(estoques);
  }

  _onClickAdd() {
    final blocPage = Provider.of<PageBloc>(context,listen: false);
      blocPage.setPage(AppPages.estoqueAdd);
  }

}
