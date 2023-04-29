
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';
import 'package:merenda_escolar/pages/pnae/pnae_add.dart';
import 'package:merenda_escolar/pages/pnae/pnae_api.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';

import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/web/utils/web_utils.dart';
import 'package:intl/intl.dart';

class PnaeListView extends StatefulWidget {
  List<Pnae> pnae;
  PnaeListView(this.pnae);

  @override
  _PnaeListViewState createState() => _PnaeListViewState();
}

class _PnaeListViewState extends State<PnaeListView> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  final tValor = TextEditingController();
  var _showProgress = false;
 
  @override
  Widget build(BuildContext context) {
    print(widget.pnae);
          return _grid(widget.pnae);

  }

  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 3 : 2;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  _grid(List<Pnae> pnaex) {
    var pnae = pnaex.reversed.toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: pnae.length,
            itemBuilder: (context, index) {
              Pnae c = pnae[index];
              return Container(
                child: _cardPnae(c),
         //       onTap: () => {},
              );
            },
          ),
        );
      },
    );
  }

  _cardPnae(Pnae c) {
    DateTime crea = DateTime.parse(c.created);
   return  Card(
     elevation: 2,
     child: ListTile(
       leading: Container(
         color: Colors.green,
         height: 50,width: 50,
         child: Container(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text(c.id.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
             ],

           ),
         ),
       ),
        title: Row(
          children: [
            Text(DateFormat("dd/MM").format(crea)),
            Text('R\$  ${formatador.format(c.valor)} '),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
       trailing:  PopupMenuButton(
         icon: Icon(Icons.more_vert),
         itemBuilder: (context) => [
           PopupMenuItem(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: InkWell(onTap: (){
                  showAlterar(context,c);},
                   child: Text("Editar")),
             ),
           ),
           PopupMenuItem(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: InkWell(onTap:(){
                 showExcluir(context,c);},
                   child: Text("Excluir")),
             ),
           ),

         ],
       ),

      ),
   );

  }

  _onClickPnae(Pnae c) {
      PagesModel nav = PagesModel.get(context);
 //    nav.push(PageInfo(c.nome, PnaeDetalhe(pnae: c)));
  }


  _onClickPnaeEdit(Pnae c) {
    PagesModel nav = PagesModel.get(context);
        nav.push(PageInfo('Cadastrar'.toString(), PnaeAdd(pnae: c)));
  }

  showAlterar(BuildContext context, Pnae c) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed:  () {
        pop(context);
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(

      child: Text("Continuar"),

      onPressed:  () async {

        _onClickAlterar(context,c,tValor.text);

        pop(context);
        pop(context);
      },

    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Altera Valor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            child: AppTextField(
              label: "Valor",
              controller: tValor,
              keyboardType: TextInputType.number,
              required: true,

            ),
          ),
        ],

      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 300,
            child: alert,
          ),
        );
      },
    );
  }

  showExcluir(BuildContext context, Pnae c) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed:  () {
        pop(context);
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(

      child: Text("Excluir"),

      onPressed:  () async {
        _onClickDeletar(context,c);
        pop(context);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text('Excluir Entrada'),
      content: Text('Tem certeza que quer remover esse item da lista?'

      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  _onClickAlterar(BuildContext context, Pnae c, String text) async {
    print('valorx ${tValor.text}');
    setState(() {
      _showProgress = true;
    });

    String quant = tValor.text;
    double quantidade;

    if(quant.contains(',')){
      quant = quant.replaceAll(".", "");
      quant = quant.replaceAll(",", ".");
      quantidade = double.parse(quant);
    }else{
      quantidade = double.parse(quant);
    }

    // Cria o usuario

    var ped = c ?? Pnae();
    ped.valor = quantidade;
    ApiResponse<bool> response = await PnaeApi.save(context, ped);

    if (response.ok) {
      print('salvando...');
      toast(context,'Item atualizado  com Sucesso');
      setState(() {
        tValor.clear();
        PagesModel.get(context).pop();;
      });
    } else {
      alert(context, response.msg);
    }

    setState(() {
      _showProgress = false;
    });
  }

  _onClickDeletar(BuildContext context, Pnae c) async {
    setState(() {
      _showProgress = true;
    });
    var ped = c ?? Pnae();
    ped.id = c.id;
    ApiResponse<bool> response = await PnaeApi.delete(context, ped);
    if (response.ok) {
      toast(context,'Item Excluído  com Sucesso');
      setState(() {
        PagesModel.get(context).pop();
      });

    } else {

      alert(context, response.msg);
    }

    setState(() {
      _showProgress = false;
    });

  }



}
