
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/gerente/compras_admin.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_add.dart';

import 'package:merenda_escolar/pages/unidadeEscolar/unidadeConsulta.dart';
import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/utils/web_utils.dart';
import 'package:supercharged/supercharged.dart';

class UnidadeEscolarListView extends StatefulWidget {
  List<UnidadeEscolar> unidadeEscolar;

  UnidadeEscolarListView(this.unidadeEscolar);

  @override
  _UnidadeEscolarListViewState createState() => _UnidadeEscolarListViewState();
}

class _UnidadeEscolarListViewState extends State<UnidadeEscolarListView> {
 
  @override
  Widget build(BuildContext context) {
    print(widget.unidadeEscolar);
          return _grid(widget.unidadeEscolar);

  }

  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 3 : 2;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid(List<UnidadeEscolar> unidadeEscolar) {
    var list = widget.unidadeEscolar.sortedByNum((e) => e.nivelescolar);
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _columns(constraints);

        return Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              UnidadeEscolar c = list[index];

              return Container(
                child: _cardUnidadeEscolar(c,constraints,index),
         //       onTap: () => {},
              );
            },
          ),
        );
      },
    );
  }

  _cardUnidadeEscolar(UnidadeEscolar c, BoxConstraints constraints, int index) {
    var i = index+1;
    return Column(
      children: [
        ListTile(
          onTap: (){
            _onClickUnidadeEscolar(c);
          },
          leading: CircleAvatar(backgroundColor: Cores.colorList[c.nivelescolar],child: Text(i.toString()),),
          title: Text(c.nome),
          trailing:  Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: Icon(Icons.edit,size: 20,), onPressed: (){
                _onClickUnidadeEscolarEdit(c);
              }),
              IconButton(icon: Icon(Icons.shopping_cart_outlined,size: 20,), onPressed: (){
                _onClickCompras(c);
              }),
            ],
          ),

        ),
        Divider()
      ],

    );


  }

  _onClickUnidadeEscolar(UnidadeEscolar c) {
      PagesModel nav = PagesModel.get(context);
     nav.push(PageInfo(c.nome, UnidadeConsulta(unidadeEscolar: c)));
  }
  _onClickCompras(UnidadeEscolar c) {
    print("JJJJ ${c.id}");

    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.nome, ComprasAdminPage(unidadeEscolar: c)));
  }

  _onClickUnidadeEscolarEdit(UnidadeEscolar c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.nome, UnidadeEscolarAdd(unidadeEscolar: c)));
  }



}
