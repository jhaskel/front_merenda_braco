
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_add.dart';
import 'package:merenda_escolar/pages/nivel/nivelConsulta.dart';
import 'package:merenda_escolar/utils/utils.dart';


class NivelListView extends StatefulWidget {
  List<Nivel> nivell;

  NivelListView(this.nivell);

  @override
  _NivelListViewState createState() => _NivelListViewState();
}

class _NivelListViewState extends State<NivelListView> {
 
  @override
  Widget build(BuildContext context) {
    print(widget.nivell);
          return _grid(widget.nivell);

  }
  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 3 : 2;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid(List<Nivel> nivell) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _columns(constraints);

        return Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: widget.nivell.length,
            itemBuilder: (context, index) {
              Nivel c = widget.nivell[index];
              return _cardNivel(c,constraints,index);
            },
          ),
        );
      },
    );
  }

  _cardNivel(Nivel c, BoxConstraints constraints, int index) {
    var i = index+1;
    return Column(
      children: [
        InkWell(
          onTap: (){
            _onClickNivel(c);
          },
          child: Container(
            height: 50,
            width: constraints.maxWidth,
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * .87,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Cores.colorList[c.id],
                        child: Text(i.toString()),
                      ),
                      SizedBox(width: 10,),
                      Text(c.nome),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth * .1,
                  child: Row(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: Icon(Icons.edit,size: 20,), onPressed: (){
                          _onClickNivelEdit(c);
                        }),
                      ],
                    ),
                  ],),
                ),

              ],
            ),
          ),
        ),
        Divider()
      ],

    );

  }

  _onClickNivel(Nivel c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.nome, NivelConsulta(nivel: c)));
  }

  _onClickNivelEdit(Nivel c) {
      PagesModel nav = PagesModel.get(context);
     nav.push(PageInfo(c.nome, NivelAdd(nivel: c)));
  }



}
