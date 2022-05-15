import 'dart:math';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_add.dart';
import 'package:merenda_escolar/pages/fornecedor/fornecedor_detalhe.dart';
import 'package:merenda_escolar/utils/utils.dart';


class FornecedorListView extends StatefulWidget {
  List<Fornecedor> fornecedor;

  FornecedorListView(this.fornecedor);

  @override
  _FornecedorListViewState createState() => _FornecedorListViewState();
}

class _FornecedorListViewState extends State<FornecedorListView> {

  @override
  Widget build(BuildContext context) {
    print(widget.fornecedor);
          return _grid(widget.fornecedor);

  }
  _grid(List<Fornecedor> fornecedor) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          padding: EdgeInsets.all(16),
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(

              itemCount: widget.fornecedor.length,
              itemBuilder: (context, index) {
                Fornecedor c = widget.fornecedor[index];

                return Container(
                  child: _cardFornecedor(c,index),
         //       onTap: () => {},
                );
              },
            ),
          ),
        );
      },
    );
  }

  _cardFornecedor(Fornecedor c,  int index) {
    return ListTile(
      onTap: ()=>_onClickFornecedor(c),
      leading: CircleAvatar(child:Text('${c.id}'),backgroundColor: c.isativo? Colors.green:Colors.grey,),
      title: Text(c.nome),
      trailing: IconButton(icon: Icon(Icons.edit,size: 20,), onPressed: (){
        _onClickFornecedorEdit(c);
      }),
    );
  }

  _onClickFornecedor(Fornecedor c) {
      PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.nome, FornecedorDetalhe(fornecedor: c)));
  }

  _onClickFornecedorEdit(Fornecedor c) {
    PagesModel nav = PagesModel.get(context);
      nav.push(PageInfo(c.nome, FornecedorAdd(fornecedor: c)));
  }



}
