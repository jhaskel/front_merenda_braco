import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/af/ordem_tab.dart';
import 'package:merenda_escolar/pages/empenho/empenho_page.dart';
import 'package:merenda_escolar/pages/escolaPage.dart';
import 'package:merenda_escolar/pages/fornecedorPage.dart';
import 'package:merenda_escolar/pages/gerente/principal.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/master/masterPage.dart';
import 'package:merenda_escolar/pages/gerente/gerentePage.dart';
import 'package:provider/provider.dart';

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  Usuario get user => AppModel.get(context).user;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    print(user.nivel);
    if(user.isUnidade() ){
      return Scaffold(
        body: _escola(),
      );
    }else if(user.isGerente()){
      return Scaffold(
        body: _gerente(),
      );
    }else if(user.isMaster()){
      return Scaffold(
        body: _master(),
      );
    }else if(user.isFornecedor()){
      return Scaffold(
        body: _fornecedor(),
      );
    }else if(user.isEmpenho()){
      return Scaffold(
        body: _empenho(),
      );
    }


  }

  _escola() {
    return PrincipalPage(user);
  }
  _gerente() {
    return GerentePage();
  }
  _master() {
    return MasterPage();
  }

  _fornecedor() {
    return FornecedorPage();
  }

  _empenho() {
    return OrdemTab();

  }




}

