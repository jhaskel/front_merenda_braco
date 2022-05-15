import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/config_bloc.dart';
import 'package:merenda_escolar/pages/af/ordem_page.dart';
import 'package:merenda_escolar/pages/af/ordem_page_autorizada.dart';
import 'package:merenda_escolar/pages/af/ordem_page_empenhada.dart';
import 'package:merenda_escolar/pages/af/ordem_page_finalizada.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:provider/provider.dart';



class OrdemTab extends StatefulWidget {
  Pedido pedido;
  OrdemTab({this.pedido});
  @override
  _OrdemTabState createState() => _OrdemTabState();
}

class _OrdemTabState extends State<OrdemTab> {

  Usuario get user => AppModel.get(context).user;
  iniciaBloc() {
    Provider.of<ConfigBloc>(context, listen: false).fetch(context);
  }

  @override
  void initState() {
  super.initState();
  iniciaBloc();

  }


  @override
  Widget build(BuildContext context) {
    if(user.isGerente()|| user.isAdmin() || user.isMaster()){
      return DefaultTabController(
        length: 4,
        child: Scaffold(
            bottomNavigationBar: Container(
              color:Colors.green[500],
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.notifications_on_rounded),text:'Novas',),
                  Tab(icon: Icon(Icons.check_circle),text:'Autorizadas',),
                  Tab(icon: Icon(Icons.bookmark),text:'Empenhadas',),
                  Tab(icon: Icon(Icons.store),text:'Finalizadas',),
                ],
              ),
            ),
            body:TabBarView(
              children: [
                OrdemPage(),
                OrdemPageAutorizada(),
                OrdemPageEmpenhada(),
                OrdemPageFinalizada(),

              ],
            )

        ),
      );

    }else

    return _empenho();

  }

  Widget _empenho() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          bottomNavigationBar: Container(
            color:Colors.green[500],
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.check_circle),text:'Autorizadas',),
                Tab(icon: Icon(Icons.bookmark),text:'Empenhadas',),
                Tab(icon: Icon(Icons.store),text:'Finalizadas',),
              ],
            ),
          ),
          body:TabBarView(
            children: [
              OrdemPageAutorizada(),
              OrdemPageEmpenhada(),
              OrdemPageFinalizada(),

            ],
          )

      ),
    );
  }
}






