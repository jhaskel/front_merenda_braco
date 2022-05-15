import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_api.dart';
import 'package:merenda_escolar/pages/af/af_bloc.dart';
import 'package:merenda_escolar/pages/af/af_detalhe.dart';
import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/afPedido/afPedido_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/utils.dart';

import 'package:intl/intl.dart';

class FornecedorPage extends StatefulWidget {
  @override
  _FornecedorPageState createState() => _FornecedorPageState();
}

class _FornecedorPageState extends State<FornecedorPage> {
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  Usuario get user => AppModel.get(context).user;
  final _blocAf= AfBloc();
  List<Af> afs;

  final _blocAfPedidos = AfPedidoBloc();
  List<AfPedido> afpedidos;

  double Total = 0;
  int quantAf = 0;
  double totalCadaAf = 0;

  double larg = 250;
  double alt = 100;
  List<Color> cores = [
    Colors.blue,Colors.purple,Colors.orange,Colors.green
  ];
  int alunos;
  bool ok = false;

  @override
  void initState() {
      _blocAf.fetchFornecedor(context,user.escola);
      _blocAfPedidos.fetch(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


                    return StreamBuilder(
                      stream: _blocAf.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return TextError("Nenhuma AF autorizada!");
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Af> listAf = snapshot.data;

                    //    var tot = listAf.map((e) => e.total);
                     //   Total = tot.reduce((a, b) => a+b);
                        quantAf =  listAf.length;


                        return StreamBuilder(
                            stream: _blocAfPedidos.stream,
                            builder: (context, snapshot) {

                              if (snapshot.hasError) {
                                return TextError("Não foi possível buscar as af");
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              List<AfPedido> listAfPedidos = snapshot.data;


                            return ListView(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      color: cores[0],
                                      width: larg,
                                      height: alt,
                                      child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('R\$ ${formatador.format( Total )}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                          Text('Valor dos pedidos',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                                        ],
                                          )
                                      ),

                                    ),
                                    Container(
                                      color: cores[1],
                                      width: larg,
                                      height: alt,
                                      child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(quantAf.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                              Text('Quantidade de AF',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),)
                                            ],
                                          )
                                      ),

                                    ),
                                  ],
                                ),
                                SizedBox(width: 50,),
                                Center(
                                  child: Container(
                                    height: 50,
                                    child: Text('Af autorizadas!',style: TextStyle(fontSize: 20),),
                                  ),
                                ),
                                Divider(thickness: 10,),
                                Container(
                                  height: 400,
                                  child: Row(
                                    children: [
                                      Container(
                                        child:  Flexible(
                                          flex: 1,
                                          child: ListView.builder(
                                              itemCount: listAf.length,
                                              itemBuilder: (context, index) {
                                                Af p = listAf[index];
                                                var tot = listAfPedidos.where((e) => e.af == p.code);
                                                var tot1 = tot.map((e) => e.total);
                                                var total = tot1.reduce((a, b) => a+b);

                                                DateTime crea = DateTime.parse(p.createdAt);
                                                if(p.status == Status.aguardandoEntrega || p.status == Status.entregue){
                                                  ok = true;
                                                }else{
                                                  ok = false;
                                                }
                                                print('ok${ok}');

                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: (){
                                                        if(p.status == Status.pedidoAutorizado){
                                                          print('sim');
                                                          _onClickStatus(p);
                                                        }
                                                        _onClickDetalhe(p);

                                                      },
                                                      leading: Container(
                                                        color: Colors.green,
                                                        height: 50,width: 50,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              child: Text(DateFormat("dd/MM").format(crea), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                            ),
                                                            Container(

                                                              child: Text(DateFormat("yyyy").format(crea), style: TextStyle(color: Colors.white),),
                                                            ),
                                                          ],

                                                        ),
                                                      ),
                                                      title: Row(
                                                        children: [
                                                          Text('${p.code} '),
                                                          Text('R\$  ${formatador.format(total)}')
                                                        ],
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      ),
                                                      subtitle: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('#${p.code}'),

                                                          Text(p.status,style: TextStyle(fontSize: 16),)

                                                        ],),
                                                      trailing:  MergeSemantics(

                                                        child: CupertinoSwitch(
                                                          value: ok,
                                                        ),
                                                      ),

                                                    ),
                                                    Divider(),
                                                  ],
                                                );
                                              }
                                          )
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                              ],
                            );
                          }
                        );

                      }



    );
  }

  @override
  void dispose() {
    _blocAf.dispose();
    _blocAfPedidos.dispose();
    super.dispose();
  }

  _onClickStatus(Af c) async {
    setState(() {
      ok = true;
    });
    print('sim');
    var cate = c ?? Af();
    cate.status = Status.aguardandoEntrega;
    await AfApi.save(context, cate);
  }


  _onClickDetalhe(Af c) {

    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo("code", AfDetalhe(c)));
  }

}



