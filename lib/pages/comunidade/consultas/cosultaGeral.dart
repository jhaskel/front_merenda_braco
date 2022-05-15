import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/graficos/gastos_por_categoria.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/graficos/gastos_por_mes.dart';
import 'package:merenda_escolar/pages/master/gastos_por_escola.dart';
import 'package:merenda_escolar/pages/master/media_por_alunos.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:merenda_escolar/utils/bloc/bloc_afs.dart';
import 'dart:convert';

import 'package:merenda_escolar/utils/bloc/bloc_pedido.dart';
import 'package:merenda_escolar/utils/utils.dart';

class ConsultaGeral extends StatefulWidget {
  @override
  _ConsultaGeralState createState() => _ConsultaGeralState();
}

class _ConsultaGeralState extends State<ConsultaGeral> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  final BlocPedido blocPedido = BlocProvider.getBloc<BlocPedido>();
  final BlocAfs blocaf = BlocProvider.getBloc<BlocAfs>();

  List<Categoria> categorias;
  double total = 0;
  double totalLimpeza =0;
  int quantAlunos = 1;
  double totalAgro = 0.001;
  double totalPnae = 0;
  double totalPorEscola = 0;
  double valorPnePorEscola = 0;
  double porcentagemAgro = 0;
  double totalPorAluno = 1;
  double totalDiversos = 0;
  double larg = 250;
  double alt = 100;
  int afSemEnviar = 0;
  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  int totalAf = 0;
  int pedidoSemAf = 0;
  //pega o total gasto no ano
  Future<double> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = '$BASE_URL/itens/total/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

  //pega a quantidade de alunos matriculados
  Future<int> getQuantAlunos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/escolas/quantAlunos';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o total gasto no ano com limmpeza
  Future<double> getTotalLimpeza() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",

    };
    var url = '$BASE_URL/itens/totalLimpeza/$ano';
    var response = await http.get(url, headers: headers);

    print("getTotalLimpeza ${(response.body)}");

    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }


 /* //pega o gasto de alimentos sem agriculatura familiar
  Future<double> getTradicional() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/itens/totalAgro/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }*/

  //pega o gasto de alimentos só da  agriculatura familiar
  Future<double> getFamiliar() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/itens/familiar/$ano';
    var response = await http.get(url, headers: headers);
    print("fami ${json.decode(response.body)}");
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
    print(json.decode(response.body));
    if(json.decode(response.body) is double){
      return (json.decode(response.body));
    }
    return 0.00;
  }

/*  //pega o total de pedidos sem af
  Future<int> getPedidoSemAf() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/pedidos/pedidoSemAf';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }*/

 /* //pega o total de pedidos sem af
  Future<int> getAfEnviada() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var url = '$BASE_URL/af/afEnviada';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }*/

  @override
  void initState() {
    super.initState();

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
      });
    });
    //gastos com alimento sem agrofamiliar
    getFamiliar().then((double) {
      totalAgro  =0;
      setState(() {
        totalAgro = double;
      });
    });

    //gastos com alimento da agrofamiliar
    getFamiliar().then((double) {
      setState(() {
        totalAgro = double;
      });
    });
    //total do pnae
    getTotalPnae().then((double) {
      totalPnae = 0;
      setState(() {
        totalPnae = double;
      });
    });
    //quantidade de pedidos sem Af
   /* getPedidoSemAf().then((int) {
      setState(() {
        pedidoSemAf = int;
      });
      print('pedidoSemAf $pedidoSemAf');
      blocPedido.inQuant.add(pedidoSemAf);
    });*/
    //quantidade de af sem enviar
  /*  getAfEnviada().then((int) {
      setState(() {
        pedidoSemAf = int;
      });
      print('pedidoSemAf $pedidoSemAf');
      blocaf.inQuant.add(pedidoSemAf);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    totalPorAluno = total / quantAlunos;
    porcentagemAgro = 0.00;

    if (totalPnae > 0 && totalAgro > 1) {

      print('totalagro $totalAgro / totalpne $totalPnae');
      print('totalagro $totalAgro / totalpne $totalPnae * 100 ');

      porcentagemAgro = (totalAgro / totalPnae) * 100;
    }

    return LayoutBuilder(builder: (context, constraints) {
      var largura = constraints.maxWidth;
      var limite = 600.0;
      return ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          largura > limite
              ? Row(
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
                              'Gasto no Ano Merenda',
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
                              'Gastos/aluno',
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
              : Row(
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
                              'Gastos no Ano Merenda',
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
                              'Gastos/aluno',
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
         largura > limite
             ? Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Text(
                        'Gastos Mensais',
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
                      child: Text(
                        'Gastos Por Categoria',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ), //B
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
                      child: Flexible(
                        flex: 1,
                        child: Card(elevation: 5, child: GastosPorMes()),
                      ),
                    ),
                    Container(
                      child: Flexible(
                        flex: 1,
                        child: Card(elevation: 5, child: GastosPorCategoria()),
                      ),
                    ),
                  ],
                ),
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
                        'Gastos Anual Por Escola',
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
                      child: Text(
                        'Média de Gastos Por Alunos',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ), //B
                    ), //Container
                  ) //Flexible
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 400,
                width: 1000,
                child: Row(
                  children: [
                    Container(
                      child: Flexible(
                        flex: 1,
                        child: Card(elevation: 5, child: GastosPorEscola()),
                      ),
                    ),
                    Container(
                      child: Flexible(
                        flex: 1,
                        child: Card(elevation: 5, child: MediaPorAlunos()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
             :Column(
           children: [
             Container(
               child: Text(
                 'Gastos Mensais',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ), //B
               //BoxDecoration
             ),
             SizedBox(height: 10,),
             Container(
               height: 400,
               width: 1000,
               child: Container(
                 child: Card(elevation: 5, child: GastosPorMes()),
               ),
             ),
             Container(
               child: Text(
                 'Gastos Por Categoria',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ), //B
             ),
             Container(
               height: 400,
               width: 1000,
               child: Container(
                 child: Card(elevation: 5, child: GastosPorCategoria()),
               ),
             ),
             SizedBox(
               height: 20,
             ),
             Container(
               child: Text(
                 'Gastos Anual Por Escola',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ), //B
               //BoxDecoration
             ),
             SizedBox(height: 10,),
             Container(
               height: 400,
               width: 1000,
               child: Container(
                 child: Card(elevation: 5, child: GastosPorEscola()),
               ),
             ),
             Container(
               child: Text(
                 'Média de Gastos Por Alunos',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ), //B
             ),
             SizedBox(
               height: 10,
             ),
             Container(
               height: 400,
               width: 1000,
               child: Container(
                 child: Card(elevation: 5, child: MediaPorAlunos()),
               ),
             ),
           ],
         )

        ],
      );
    });
  }
}
