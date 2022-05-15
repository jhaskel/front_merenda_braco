
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/core/bloc/setor_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/pages/setor/setor_listview.dart';
import 'package:provider/provider.dart';


class SetorPage extends StatefulWidget {
  Usuario user;
  SetorPage(this.user);


  @override
  _SetorPageState createState() => _SetorPageState();
}

class _SetorPageState extends State<SetorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;


  bool _isLoading = true;
  List<Setor> setors;
  List<Setor> lt;

  iniciaBloc() {

   Provider.of<SetorBloc>(context, listen: false).fetch(context).then((_) {
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
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Nova Setor',
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

  _body(){
   final bloc = Provider.of<SetorBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
      lt = bloc.lista;
    return SetorListView(lt);
  }


  _onClickAdd() {
    final blocPage = Provider.of<PageBloc>(context,listen: false);
      blocPage.setPage(AppPages.setorAdd);

  }



}
