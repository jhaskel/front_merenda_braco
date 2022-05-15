import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';

import 'package:merenda_escolar/pages/compras/compras_listview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';


class ComprasPage extends StatefulWidget {
  List<Produto> listProdutos;
  ComprasPage({this.listProdutos});

  @override
  _ComprasPageState createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {


  Usuario get user => AppModel.get(context).user;
  int temCart = 1000;
  int quantCart = 0;
  Future<int> getTemCart() async {

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/temcart/${user.escola}';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }

  @override
  void initState() {
    getTemCart().then((int) async {
      setState(() {
        temCart = int;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(temCart == 1000){
      return Container();
    }else{
      return _comprar(temCart,widget.listProdutos);
    }
  }

  _comprar(int temCart, List<Produto> listProdutos) {
    return Scaffold(
      body: ComprasListView(temCart,listProdutos),
    );
  }
}
