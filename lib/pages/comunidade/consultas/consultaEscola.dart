import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';

import 'dart:convert';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';


import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_categoria_escola.dart';
import 'package:merenda_escolar/utils/graficos/grafCol.dart';
import 'package:merenda_escolar/utils/graficos/piza.dart';


import 'package:merenda_escolar/utils/utils.dart';
import 'package:validadores/ValidarEmail.dart';

class ConsultaEscola extends StatefulWidget {
  final int escola;
  ConsultaEscola(this.escola);

  @override
  _ConsultaEscolaState createState() => _ConsultaEscolaState();
}

class _ConsultaEscolaState extends State<ConsultaEscola> {

  int get escola=>widget.escola;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  List<Categoria> categorias;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> listItens;
  double total =0;
  double totalLimpeza =0;
  int quantAlunos =1;
  double totalAgro = 0.001;
  double totalPnae=0;
  double totalPorEscola=0 ;
  double valorPnePorEscola =0;
  double porcentagemAgro=0;
  double totalPorAluno=0 ;
  double totalTradicional =0;
  double larg = 250;
  double alt = 100;
  int quantEscolas =1;
  int atual;
  List<Customer> list3 = [];
  bool temCategorias = false;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  int totalAf ;
  List<Customer> list2 = [];
  //pega a quantidade de escolas
  Future<int> getQuantEscola() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",

    };
    var url = '$BASE_URL/escolas/quantidade';
    var response = await http.get(url, headers: headers);

    return (json.decode(response.body));
  }

  //pega o total gasto no ano
  Future<double> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",

    };
    var url = '$BASE_URL/itens/totalEscola/$escola/$ano';
    var response = await http.get(url, headers: headers);

    print("getTotalXX ${(response.body)}");

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
    var url = '$BASE_URL/itens/totalEscolaLimpeza/$escola/$ano';
    var response = await http.get(url, headers: headers);

    print("getTotalLimpeza ${(response.body)}");

    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

  //pega a quantidade de alunos matriculados na escola
  Future<int> getQuantAlunos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",

    };
    var url = '$BASE_URL/escolas/quantAlunosEscola/$escola';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }


  //pega o gasto de alimentos só da  agriculatura familiar
  Future<double> getFamiliar() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/itens/familiarEscola/$escola/$ano';
    var response = await http.get(url, headers: headers);

    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

  //pega o valor total do pnae
  Future<double> getTotalPnae() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/pnae/soma/$ano';
    var response = await http.get(url, headers: headers);

    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

  //pega o total por categoria
  List<PedidoItens> listCategorias = [];
  Future<List<PedidoItens>> getTotalCategoria() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/itens/totalCategoriaEscola/${escola}/$ano';
    var response = await http.get(url,headers: headers);
    print('list categorias ${response.body}');
    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

bool lendo = false;
  iniciaBloc() async {



   quantAlunos = 1;
   totalAgro = 0.01;
   totalPnae = 0.01;
   totalPorEscola = 0;

   totalTradicional = 0;
   quantEscolas = 1;
   totalAf = 0;
  atual = escola;



   _blocItens.fetchTotalMesEscola(context, escola, ano).then((value) {

     setState(() {

       List<PedidoItens> listItens = value;
       listItens.sort((a, b) => a.id.compareTo(b.id));
       print('listItens1x ${listItens}');
       for (var y in listItens) {
         print('aqui ${y.mes}');
       }
       int i2 = 0;
       print('listItens2x ${listItens}');
       list3.clear();
       for (var c in listItens) {
         list3.add(Customer(c.mes, c.tot, Cores.colorList[i2]));
         i2++;
       }
       print('LIST3 ${list3}');
    lendo = false;

     });
   });

   getQuantEscola().then((int) {
      setState(() {
        quantEscolas = int;
        print('quantEscolas${quantEscolas}');
      });
    });

    //gastos no ano
    getTotal().then((double) {
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
    //quantidade de alunos
    getQuantAlunos().then((int) {
      setState(() {
        quantAlunos = int;
        print('quantAlunos${quantAlunos}');
      });
    });
    //gastos com alimento sem agrofamiliar


    //gastos com alimento da agrofamiliar
    getFamiliar().then((double) {
      setState(() {
        totalAgro = double;
        print('totalAgro${totalAgro}');
      });
    });
    //total do pnae
    getTotalPnae().then((double) {
      setState(() {
        totalPnae = double;
      });
    });

     getTotalCategoria().then((value){
      setState(() {

        listCategorias = value;
        int i2 = 0;
        list2.clear();
        for(var c in listCategorias){
          list2.add(Customer(c.nomec, c.tot.toDouble(), Cores.colorList[i2]));
          i2++;
        }
        temCategorias = true;

      });
    });
   setState(() {
     lendo = true;
   });
  }



  @override
  void initState() {
    super.initState();
    //quantidade de escola
    iniciaBloc();

  }

  @override
  Widget build(BuildContext context) {
  if(atual != escola){
    print("JJJ");
  iniciaBloc();
  }

  print('KKKKKKKK$escola');
    totalPorAluno = total / quantAlunos;

    if (totalPnae > 0 && totalAgro > 1) {
      valorPnePorEscola = totalPnae / quantEscolas;
      porcentagemAgro = (totalAgro / valorPnePorEscola) * 100;
    }
    print("TY00 $total");
    print("TY0 $quantEscolas");
    print("TY1 $totalPnae");
    print("TY2 $totalAgro");
    print("TY3 $valorPnePorEscola");
    print("TY4 $porcentagemAgro");
  return LayoutBuilder(builder: (context, constraints) {
    var largura = constraints.maxWidth;
    var limite = 600.0;
    return ListView(
      children: [
        SizedBox(height: 10,),
        largura > limite? Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[0],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${formatador.format(total)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Gastos com merenda',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[1],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${formatador.format(totalLimpeza)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Gastos com Limpeza',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[2],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${formatador.format(totalPorAluno)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Gastor por aluno',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[3],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${porcentagemAgro.toStringAsFixed(2)} %',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Agro Familiar',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
          ],
        )
        :Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[0],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${formatador.format(total)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Gastos anual',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[1],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'R\$ ${formatador.format(totalPorAluno)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Gastos/ aluno',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),

            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[3],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${porcentagemAgro.toStringAsFixed(2)} %',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Agro Familiar',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Text(
                  'Gastos com merenda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ), //B
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
            ) //FSizedBox
            //Flexible
          ],
        ),
        Container(
          height: 400,
          width: 1000,
          child: Row(
            children: [
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(
                      elevation: 5,
                      child:  !lendo ?GrafCol(
                          list3,true
                      ):Container()

                  ),
                ),

              ),
              Container(
                child:  Flexible(
                  flex: 1,
                    child:  temCategorias
                        ? Piza(list2):Container()
                ),
              ),

            ],
          ),
        ),
      ],
    );
  });


  }

  @override
  void dispose() {
    super.dispose();
    _blocItens.dispose();
  }
}
