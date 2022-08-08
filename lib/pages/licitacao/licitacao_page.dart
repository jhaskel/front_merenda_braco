
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/licitacao_bloc.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_add.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_pages.dart';


class LicitacaoPage extends StatefulWidget {
  @override
  _LicitacaoPageState createState() => _LicitacaoPageState();
}

class _LicitacaoPageState extends State<LicitacaoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  bool _isLoading = true;
  List<Licitacao> licitacaos;
  List<Licitacao> lista;

  iniciaBloc() {
   Provider.of<LicitacaoBloc>(context, listen: false).fetch(context).then((_) {
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
      body: _body(),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Container(),
      ),
    );
  }

  _body(){
   final bloc = Provider.of<LicitacaoBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
      lista = bloc.lista;

   lista.sort((a, b) => b.isativo.toString().compareTo(a.isativo.toString()));

   return  Scaffold(
     body: BreadCrumb(
       child:LicitacaoListView(lista),
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
    nav.push(PageInfo('Nova Licitação', LicitacaoAdd()));
  }



}
