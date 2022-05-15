

import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';


class NivelDetalhe extends StatelessWidget {
  final Nivel nivell;
  NivelDetalhe({this.nivell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(nivell.nome ?? ""),

      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          nivell.nome != null
              ? Image.network(nivell.nome)
              : FlutterLogo(
                  size: 100,
                )
        ],
      ),
    );
  }



}
