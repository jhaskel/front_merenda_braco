
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/bloc/nivel_bloc.dart';
import 'package:merenda_escolar/core/bloc/unidade_bloc.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/pages/setor/setor_edit.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:provider/provider.dart';



class SetorDetalhe extends StatefulWidget {
  final Setor setor;
  SetorDetalhe({this.setor});

  @override
  _SetorDetalheState createState() => _SetorDetalheState();
}

class _SetorDetalheState extends State<SetorDetalhe> {

  Setor get dados =>widget.setor;
  bool _showProgress = false;
  @override
  Widget build(BuildContext context) {
    return !_showProgress ?Scaffold(
      appBar: AppBar(title: Text(dados.nome),

      ),
      body: _body(),

    ):CircularProgressIndicator();
  }

  _body() {
    return LayoutBuilder(
        builder: (context,constraints){
         double altura = constraints.maxHeight;
         double largura = constraints.maxWidth;
          return ListView(
            children: [
              Row(
                children: [
                  Container(
                    width: largura > 1100 ?largura *.7:largura,
                    height: altura,

                    child: Coluna1(widget.setor),
                  ),
                  Container(
                    width: largura > 1100 ?largura *.3:largura*0,
                    height: altura,
                    color: Colors.green,
                    child: Coluna2(),
                  ),

                ],

              ),
              largura < 1100? Container(
                height: altura,
                color: Colors.green,
                child: Coluna2(),
              ):Container(),

            ],
          );

        });

  }

  _onClickAdd() {
    setState(() {
      push(context, SetorEdit(setor: dados,));
    });
  }


}

class Coluna1 extends StatefulWidget {
   Setor setor;
   Coluna1(this.setor,{
    Key key,
  }) : super(key: key);

  @override
  State<Coluna1> createState() => _Coluna1State();
}

class _Coluna1State extends State<Coluna1> {
  double quantNiveis = 0;
  double quantUnidades = 0;
  double quantGasto = 0;
  double quantItens= 0;
  List<Nivel> niveis;
  List<UnidadeEscolar> unidades;
  bool _isLoading = true;



  iniciaBloc() {
    Provider.of<NivelBloc>(context, listen: false).fetchSetor(context,widget.setor.id).then((value) {
      setState(() {
         niveis = value;
         quantNiveis=value.length.toDouble();
        _isLoading = false;

      });});
    Provider.of<UnidadeBloc>(context, listen: false).fetchSetor(context,widget.setor.id).then((value) {
      setState(() {
        unidades = value;
         quantUnidades=value.length.toDouble();
        _isLoading = false;
      });});
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: 20,),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            mostrador('Niveis',0,quantNiveis),
            mostrador('Unidades',1,quantUnidades),
            mostrador('Gasto',2,quantGasto),
            mostrador('Itens comprados',3,quantItens),

          ],
        ),
        Text("VERMELHO"),
      ],
    );
  }

   mostrador(String title,int index, double valores) {
    return LayoutBuilder(builder: (context, constraints){
      print(constraints.maxWidth);
      return Container(
        width: 200,
        height: 70,
        decoration: BoxDecoration(
          gradient: Mostrador.gradient[index],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Icon(Mostrador.icones[index],size: 40,color: Colors.white,)),
            Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(valores.toStringAsFixed(0),style:TextStyle(color: Colors.white,fontSize: 27
                    )),

                    Text(title,style:TextStyle(color: Colors.white,fontSize: 15
                    )),
                  ],
                )),


          ],

        ),
      );
    });


  }
}

class Coluna2 extends StatelessWidget {
  const Coluna2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("VERDE"),);
  }
}
