import 'dart:html';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_bloc.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_bloc.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_bloc.dart';

import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_categoria_escola.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/graficos/gastos_por_mes_escola.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';

import 'package:merenda_escolar/utils/graficos/grafCol.dart';

import 'package:merenda_escolar/utils/graficos/piza.dart';

import 'package:merenda_escolar/utils/utils.dart';

import 'package:merenda_escolar/web/utils/prefs.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../constants.dart';

class EscolaPage extends StatefulWidget {
  @override
  _EscolaPageState createState() => _EscolaPageState();
}

class _EscolaPageState extends State<EscolaPage> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  Usuario get user => AppModel.get(context).user;

  final _bloc = UnidadeEscolarBloc();
  List<UnidadeEscolar> escolas;

  final _blocNivel = NivelBloc();
  List<Nivel> niveisEscolares;

  int ano = DateTime.now().year;
  double total = 0;
  double itensCart = 0;
  double totalAgro = 0;
  double totalPnae = 1;
  int escola;

  double valorPnePorEscola = 0;
  double porcentagemAgro = 0;
  int quantEscolas = 0;

  double totalTradicional = 0;

  double larg = 250;
  double alt = 100;
  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;

  int quantAlunos = 1;

  double totalPorEscola = 0;

  double totalPorAluno = 1;
  double totalDiversos = 0;

  //pega a quantidade de escolas
  Future<int> getQuantEscola() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantidade';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

//pega o total gasto no ano por escola
  Future<double> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/totalEscola/${user.escola}/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

//pega a quantidade de alunos matriculados por escola
  Future<int> getQuantAlunos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantAlunosEscola/${user.escola}';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o gasto de alimentos tradicionais
  Future<double> getTradicional() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/tradicionalEscola/${user.escola}/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

//pega o valor total do pnae
  Future<double> getTotalPnae() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

    var url = '$BASE_URL/pnae/soma/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

//pega o valor total da categoria 4 e 7
  Future<double> getDiversos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

    var url = '$BASE_URL/itens/diversosEscola/${user.escola}/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }



  @override
  void initState() {
    super.initState();

    _bloc.fetchId(context,user.escola);
    _blocNivel.fetch(context);


    getTotal().then((double) {
      setState(() {
        total = double;
      });
    });
    getQuantEscola().then((int) {
      setState(() {
        quantEscolas = int;
        print('quantEscolas${quantEscolas}');
      });
    });

    getTradicional().then((double) {
      setState(() {
        totalTradicional = double;
      });
    });

    getQuantAlunos().then((int) {
      setState(() {
        quantAlunos = int;
      });
    });

    getTotalPnae().then((double) {
      setState(() {
        totalPnae = double;
      });
    });

    getDiversos().then((double) {
      setState(() {
        totalDiversos = double;
      });
    });


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
    return ListView(
      children: <Widget>[
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
                color: cores[2],
                height: alt,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('R\$ ${formatador.format( totalTradicional )}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Tradicional',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
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
        SizedBox(height: 20,),
        Container(
          height: 400,
          width: 1000,
          child: Row(
            children: [
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(elevation:5,child: GastosPorMesEscola(user.escola)),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(elevation:5,child: GastosPorCategoriaEscola(user.escola)),
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
            stream: _blocNivel.stream,
            builder: (context, snapshot0) {
              if (snapshot0.hasError) {
                return TextError("Não foi possível buscar os níveis escolares");
              }
              if (!snapshot0.hasData) {
                return Center(
                  child: Container(),
                );
              }

              List<Nivel> listNiveis = snapshot0.data;

              return StreamBuilder(
                  stream: _bloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return TextError(
                          "Não foi possível buscar os níveis escolaress");
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(),
                      );
                    }
                    List<UnidadeEscolar> unidadeEscolar = snapshot.data;
                    UnidadeEscolar escola = unidadeEscolar.first;

                    Prefs.setInt("idEscola", escola.id);
                    Prefs.setInt("idNivel", escola.nivelescolar);
                    Prefs.setString("nomeEscola", escola.alias);

                    return  Container();
                  });
            }),


      ],
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _blocNivel.dispose();

    super.dispose();
  }
}
