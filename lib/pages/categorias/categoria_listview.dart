
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_api.dart';
import 'package:merenda_escolar/pages/categorias/categoria_add.dart';

import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/utils/web_utils.dart';

class CategoriaListView extends StatefulWidget {
  List<Categoria> categoria;

  CategoriaListView(this.categoria);

  @override
  _CategoriaListViewState createState() => _CategoriaListViewState();
}

class _CategoriaListViewState extends State<CategoriaListView> {
  bool _isativo;
 
  @override
  Widget build(BuildContext context) {
    print(widget.categoria);
          return _grid(widget.categoria);

  }

  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 3 : 2;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid(List<Categoria> categoria) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _columns(constraints);

        return Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(

            itemCount: widget.categoria.length,
            itemBuilder: (context, index) {
              Categoria c = widget.categoria[index];
              _isativo = c.isativo;

              return Container(
                child: _cardCategoria(c,constraints),
         //       onTap: () => {},
              );
            },
          ),
        );
      },
    );
  }

  _cardCategoria(Categoria c, BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          height: 50,
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(


                  children: [
                    CircleAvatar(backgroundColor: Cores.colorList[c.id],),
                    SizedBox(width: 10,),
                    Text(c.nome),
                  ],
                ),
              ),
              Container(
                child: Row(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(icon: Icon(Icons.edit,size: 20,), onPressed: (){
                        _onClickCategoriaEdit(c);
                      }),
                      MergeSemantics(
                        child: CupertinoSwitch(
                           value:_isativo,
                           onChanged: (bool newValue) {
                             setState(() {
                               _isativo = newValue;
                             });
                            alteraStatus(newValue,c);
                          },
                        ),
                      ),
                    ],
                  ),
                ],),
              ),



            ],
          ),
        ),
        Divider()
      ],

    );
  }

  _onClickCategoria(Categoria c) {
      PagesModel nav = PagesModel.get(context);
 //    nav.push(PageInfo(c.nome, CategoriaDetalhe(categoria: c)));
  }


  _onClickCategoriaEdit(Categoria c) {
    PagesModel nav = PagesModel.get(context);
 //       nav.push(PageInfo(c.nome, CategoriaAdd(categoria: c)));
  }



  void alteraStatus(bool newValue, Categoria c)  {
      var cate = c ?? Categoria();
      cate.isativo = newValue;
      CategoriaApi.save(context, cate);

  }

}
