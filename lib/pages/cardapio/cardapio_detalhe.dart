import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';


class CardapioDetalhe extends StatefulWidget {
final Cardapio cardapio;
  CardapioDetalhe({Key key,this.cardapio }) : super(key: key);

  @override
  _CardapioDetalheState createState() => _CardapioDetalheState();
}

class _CardapioDetalheState extends State<CardapioDetalhe> {

Cardapio get c=>widget.cardapio;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text(c.nomedaescola),),
    body: _body(),
        );


      }

      _body() {

    return ListView(
      children: [

      Container(child:Text(c.title,style: AppTextStyles.body20,textAlign: TextAlign.center,)),
      SizedBox(height: 30,),
      Container(
      child:
     Padding(
       padding: const EdgeInsets.all(20.0),
       child: Image.network(
            c.imagem,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
     ),

      ),


      ],
       );



      }
}
