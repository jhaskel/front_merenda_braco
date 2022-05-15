

import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("VERSÃO ATUAL 1.0.3",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 40,),
            Text("ChangeLogs"),
            SizedBox(height: 15,),
            Text("* 1.0.3 - Acrescentado descrição completa do produto no card de compras"),
            Text("* 1.0.3 - Acrescentado valor decimal na quantidade comprada no card de compras"),
            Text("* 1.0.2 - Correções de bugs"),
            Text("* 1.0.1 - Correções de bugs"),
            Text("* 1.0.0 - Lançamento Oficial"),
          ],


        ),

      ),
    );

  }
}
