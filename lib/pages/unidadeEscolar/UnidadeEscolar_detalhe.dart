
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';

class UnidadeEscolarDetalhe extends StatelessWidget {
  final UnidadeEscolar unidadeEscolar;
  UnidadeEscolarDetalhe({this.unidadeEscolar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(unidadeEscolar.nome ?? ""),

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
          unidadeEscolar.nome != null
              ? Image.network(unidadeEscolar.nome)
              : FlutterLogo(
                  size: 100,
                )
        ],
      ),
    );
  }



}
