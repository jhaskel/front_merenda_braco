import 'dart:html';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/master/gastos_por_categoria.dart';
import 'package:merenda_escolar/pages/master/gastos_por_escola.dart';
import 'package:merenda_escolar/pages/master/gastos_por_mes.dart';
import 'package:merenda_escolar/pages/master/media_por_alunos.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  Usuario get user => AppModel.get(context).user;

  final _blocCategoria= CategoriaBloc();
  List<Categoria> categorias;

  double total = 0;
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
  List<Color> cores = [
    Colors.blue,Colors.purple,Colors.orange,Colors.green
  ];
  int alunos;
  int ano = DateTime.now().year;

  final BlocAf blocx = BlocProvider.getBloc<BlocAf>();
  int totalAf = 0;

//pega a quantidade de af não autorizadas e joga no header
  Future<int> getTotalAf() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/af/af';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }

//pega o total gasto no ano
  Future<double> getTotal() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/total/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }

//pega a quantidade de alunos matriculados
  Future<int> getQuantAlunos() async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantAlunos';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }

  //pega o gasto por escola
  Future<double> getTotalPorEscola(int escola) async {
    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/somaAll/$escola';
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
    var url = '$BASE_URL/itens/tradicional/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
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
    return  (json.decode(response.body));
  }


//pega o valor total da categoria 4 e 7
  Future<double> getDiversos() async {

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"    };

    var url = '$BASE_URL/itens/diversos/$ano';
    var response = await http.get(url,headers: headers);
    print(json.decode(response.body));
    return  (json.decode(response.body));
  }



  void _pegaTotalAf() {
    getTotalAf().then((int){
      setState(() {
        totalAf = int;
        print('totalAf ${totalAf}');
        blocx.inAf.add(totalAf);
      });
    });
  }


  @override
  void initState() {

     _pegaTotalAf();

      getTotal().then((double){
        setState(() {
          total = double;
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
           print('entrou');
           porcentagemAgro  = (totalAgro/totalPnae)*100;
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
                      child: Card(elevation:5,child: GastosPorMes()),
                    ),
                  ),
                  Container(
                    child:  Flexible(
                      flex: 1,
                      child: Card(elevation:5,child: GastosPorCategoria()),
                    ),
                  ),
                ],
              ),

            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    child: Text('Gastos Anual Por Escola',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),//B
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
                    child: Text('Média de Gastos Por Alunos',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),//B
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
                    child:  Flexible(
                      flex: 1,
                      child: Card(elevation:5,child: GastosPorEscola()),
                    ),
                  ),
                  Container(
                    child:  Flexible(
                      flex: 1,
                      child: Card(elevation:5,child: MediaPorAlunos()),
                    ),
                  ),
                ],
              ),

            )

          ],
        );
    }


}




