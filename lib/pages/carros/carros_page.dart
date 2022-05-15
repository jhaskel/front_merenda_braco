

import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/carros/carro_form_page.dart';
import 'package:merenda_escolar/pages/carros/carros_list.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class CarrosPage extends StatefulWidget {
  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage> {
  Usuario get user => AppModel.get(context).user;

  @override
  Widget build(BuildContext context) {
    return user.isGerente() ? _admin() : _user();
  }

  _user() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: CarrosListView(),
    );
  }

  _admin() {
    return Scaffold(
      body: BreadCrumb(
        child: CarrosListView(),
        actions: [
          AddButton(
            onPressed: _onClickAdd,
          )
        ],
      ),
    );
  }

  // Adicionar novo carro
  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("Carros", CarroFormPage()));
  }
}
