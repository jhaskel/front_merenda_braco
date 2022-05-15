import 'dart:html';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_categoria_escola.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_escola_escola.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_mes_escola.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/media_por_alunos_escola.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:merenda_escolar/web/breadcrumb.dart';

class UnidadeConsulta extends StatefulWidget {
  UnidadeEscolar unidadeEscolar;
  UnidadeConsulta({this.unidadeEscolar});
  @override
  _UnidadeConsultaState createState() => _UnidadeConsultaState();
}

class _UnidadeConsultaState extends State<UnidadeConsulta> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  Usuario get user => AppModel.get(context).user;

  double total = 0;
  double totalLimpeza =0;
  int quantAlunos = 1;
  double totalAgro = 0;
  double totalPnae = 1;
  double totalPorEscola = 0;
  double valorPnePorEscola =0;
  double porcentagemAgro = 0;
  double totalPorAluno = 1;
  double totalDiversos= 0;
  double totalTradicional =0 ;
  double larg = 250;
  double alt = 100;
  int quantEscolas =1 ;
  List<Color> cores = [
    Colors.blue,Colors.purple,Colors.orange,Colors.green
  ];
  int alunos;
  int ano = DateTime.now().year;

   //pega a quantidade de escolas
  Future<int> getQuantEscola() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantidade';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }

//pega o total gasto no ano por escola
  Future<double> getTotal() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/totalEscola/${widget.unidadeEscolar.id}/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }
  //pega o total gasto no ano com limmpeza
  Future<double> getTotalLimpeza() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",

    };
    var url = '$BASE_URL/itens/totalEscolaLimpeza/${widget.unidadeEscolar.id}/$ano';
    var response = await http.get(url, headers: headers);

    print("getTotalLimpeza ${(response.body)}");

    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

//pega a quantidade de alunos matriculados por nivel
  Future<int> getQuantAlunos() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantAlunosEscola/${widget.unidadeEscolar.id}';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }


  //pega o gasto de alimentos tradicionais
  Future<double> getTradicional() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/tradicionalEscola/${widget.unidadeEscolar.id}/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }


//pega o valor total do pnae
  Future<double> getTotalPnae() async {

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

    var url = '$BASE_URL/pnae/soma/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }


//pega o valor total da categoria 4 e 7
  Future<double> getDiversos() async {

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"    };

    var url = '$BASE_URL/itens/diversosEscola/${widget.unidadeEscolar.id}/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }


  @override
  void initState() {

    getTotal().then((double){
      setState(() {
        total = double;
      });
    });
    //gastos no ano
    getTotalLimpeza().then((double) {
      setState(() {
        totalLimpeza = double;
      });
    });
    getQuantEscola().then((int){
      setState(() {
        quantEscolas = int;
        print('quantEscolas${quantEscolas}');
      });
    });

    getTradicional().then((double){
      setState(() {
        totalTradicional = double;
      });
    });

    getQuantAlunos().then((int){
      setState(() {
        quantAlunos = int;
      });
    });


    getTotalPnae().then((double){
      setState(() {
        totalPnae = double;
      });
    });


    getDiversos().then((double){
      setState(() {
        totalDiversos = double;

      });
    });




    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    totalPorAluno = total/quantAlunos;
    if(totalTradicional > 0 && totalDiversos > 0){
      totalAgro = total - totalTradicional - totalDiversos;
      if(totalAgro > 0){
        if(totalPnae > 1){
          double pnaeEscola = totalPnae/quantEscolas;
          print('entrou');
          porcentagemAgro  = (totalAgro/pnaeEscola)*100;
        }
      }
    }

    return BreadCrumb(child: ListView(
      children: <Widget>[
        SizedBox(height: 20,),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(widget.unidadeEscolar.nome,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
            ],),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: cores[0],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('R\$ ${formatador.format( total )}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Total gasto no Ano',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                      ],
                    )
                ),

              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: cores[2],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('R\$ ${formatador.format( totalLimpeza )}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Limpeza/higiene',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                      ],
                    )
                ),

              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: cores[1],

                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('R\$ ${formatador.format( totalPorAluno )}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Gastor por aluno',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                      ],
                    )
                ),

              ),
            ),

            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: cores[3],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${ porcentagemAgro.toStringAsFixed(2)} %',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Agro Familiar',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                      ],
                    )
                ),

              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Text('Gastos Mensais',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),//B
                //BoxDecoration
              ), //Container
            ), //Flexible
            SizedBox(
              width: 20,
            ), //SizedBox
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Text('Gastos Por Categoria',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),//B
              ), //Container
            ) //Flexible
          ],
        ),
        Container(
          height: 400,
          width: 1000,
          child: Row(
            children: [
              Container(
                child:  Flexible(
                  flex: 1,
                  child: Card(elevation:5,child: GastosPorMesEscola(widget.unidadeEscolar.id)),
                ),
              ),
              Container(
                child:  Flexible(
                  flex: 1,
                  child: Card(elevation:5,child: GastosPorCategoriaEscola(widget.unidadeEscolar.id)),
                ),
              ),
            ],
          ),

        ),


      ],
    ));
  }


}




