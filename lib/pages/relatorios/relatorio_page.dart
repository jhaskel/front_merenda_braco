import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/relatorios/Produto_menos.dart';
import 'package:merenda_escolar/pages/relatorios/produto_mais_pedido.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class RelatorioPage extends StatelessWidget {
  Usuario user;
  RelatorioPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BreadCrumb(
        child: _body(context),
      )
    );
  }

  Container _body(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SizedBox(height: 10,),
        ListTile(
           onTap: (){
             _onClickMaisPedido(context);
           },
           title: Text("Produtos Mais Pedidos"),
         ),
        Divider(height: 2,thickness: 2,),
        ListTile(
            onTap: (){
              _onClickMenosPedido(context);
            },
            title: Text("Produtos Não Pedido"),
          ),
          Divider(height: 2,thickness: 2,),


        ],
      )
    );
  }


  void _onClickMaisPedido(context){
    PagesModel.get(context).push(PageInfo("Mais Pedidos",ProdutoMaisPedido()));

  }
  void _onClickMenosPedido(context){
    PagesModel.get(context).push(PageInfo("Mais Pedidos",ProdutoMenos()));

  }
}
