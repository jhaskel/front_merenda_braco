import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_bloc.dart';
import 'package:merenda_escolar/pages/af/af_detalhe.dart';
import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/afPedido/afPedido_bloc.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_bloc.dart';

import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

import 'package:intl/intl.dart';

import 'dart:async';
import 'package:appbar_textfield/appbar_textfield.dart';

class OrdemPageProcessado extends StatefulWidget {
  @override
  _OrdemPageProcessadoState createState() => _OrdemPageProcessadoState();
}

class _OrdemPageProcessadoState extends State<OrdemPageProcessado> {
  List<Af> _allContacts = List<Af>();
  StreamController<List<Af>> _contactStream =
  StreamController<List<Af>>();

  Usuario get user => AppModel.get(context).user;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  final _blocFor = FornecedorBloc();
  List<Fornecedor> fornecedors;
  ScrollController _controller = ScrollController();

  final _blocNivel = NivelBloc();
  List<Nivel> Nivell;

  final _blocAf = AfBloc();
  List<Af> afs;
  int busca = 1;

  final _blocAfPedidos = AfPedidoBloc();
  List<AfPedido> afpedidos;

  String nomeNivel;

  @override
  void initState() {
    _blocFor.fetch(context);
    _blocNivel.fetch(context);
    _blocAfPedidos.fetch(context);
    _blocAf.fetchDespesa(context,true).then((value) {
      print("affx $value");
      setState(() {
        for(var x in value){
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(nomeNivel);

    return Scaffold(

      body:BreadCrumb(

        child:  _body(),
      ),
    );
  }


  StreamBuilder<List<Fornecedor>> _body() {
    return StreamBuilder(
        stream: _blocFor.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar as fornecedores");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Fornecedor> listFor = snapshot.data;
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
                  print('haskel');
                  List<AfPedido> listAfPedidos = snapshot.data;
                  return Container(
                    child: StreamBuilder(
                        stream: _blocAf.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return TextError("Não foi possível buscar as af");
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Af> listAfsSem = snapshot.data;
                          List<Af> listAfs = listAfsSem
                              .where((element) => element.isativo == true)
                              .toList();

                          if (listAfs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextError("Não foram encontrados nenhum registro!"),
                                ],
                              ),
                            );
                          }

                          return StreamBuilder(
                              stream: _blocNivel.stream,
                              builder: (context, snapshot3) {
                                if (snapshot3.hasError) {
                                  return TextError(
                                      "Não foi possível buscar os niveis escolares");
                                }
                                if (!snapshot3.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List<Nivel> listNiveis = snapshot3.data;
                                print('niv ${listNiveis}');

                                return Container(
                                    child: _admin(listAfs, listFor, listNiveis,listAfPedidos));
                              });
                        }),
                  );
                }
              );

        });
  }

  _admin(List<Af> lisItens, List<Fornecedor> listFor,
    List<Nivel> listNiveis, List<AfPedido> listAfPedidos) {
    int _columns(constraints) {
      int columns = constraints.maxWidth > 800 ? 3 : 2;
      if (constraints.maxWidth <= 500) {
        columns = 1;
      }
      return columns;
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 30,
            child: Row(
              children: [
                InkWell(
                  child:
                  Chip(
                    backgroundColor: busca == 1? Colors.green:Colors.black26,
                    label: Text('Por Empresa')),
                  onTap: (){
                    setState(() {
                      busca = 1;
                    });
                  },
                ),
                SizedBox(width: 5,),
                InkWell(
                  child:
                  Chip(
                      backgroundColor: busca == 2? Colors.green:Colors.black26,
                      label: Text('Por Codigo')),
                  onTap: (){
                    setState(() {
                      busca = 2;
                    });
                  },
                ),
                SizedBox(width: 5,),
                InkWell(
                  child:
                  Chip(
                      backgroundColor: busca == 3? Colors.green:Colors.black26,
                      label: Text('Por Status')),
                  onTap: (){
                    setState(() {
                      busca = 3;
                    });
                  },
                ),


              ],
            ),
          ),
          Container(
            height: 50,
            child: AppBarTextField(
              backgroundColor: Colors.transparent,
              title: Text("Buscar...."),
              onBackPressed: _onRestoreAllData,
              onClearPressed: _onRestoreAllData,
              onChanged: _onSimpleSearch2Changed,
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              showTrackOnHover: true,
              thickness: 10,
              radius: Radius.circular(15),

              child: StreamBuilder<List<Af>>(
                  stream: _contactStream.stream,
                  builder: (context, snapshot) {
                    List<Af> contacts = snapshot.hasData ? snapshot.data : [];
                  return ListView.builder(
                    controller: _controller,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        Af p = contacts[index];
                        var filtro = listFor
                            .where((element) => element.id == p.fornecedor)
                            .toList();

                        var nome = filtro.map((e) => e.nome).first;

                        var filtroNivel = listNiveis
                            .where((element) => element.id == p.nivel)
                            .toList();

                        var nomeNivel = filtroNivel.map((e) => e.nome).first;
                        DateTime crea = DateTime.parse(p.createdAt);

                        var tot = listAfPedidos.where((e) => e.af == p.code);
                        var tot1 = tot.map((e) => e.total);
                        var total = tot1.reduce((a, b) => a+b);


                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                _onClickDetalhe(p);
                              },
                              leading: Container(
                                color: Colors.green,
                                height: 50,
                                width: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        DateFormat("dd/MM").format(crea),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        DateFormat("yyyy").format(crea),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              title: Row(
                                children: [
                                  Row(
                                    children: [
                                      Text('#${p.code.toString()}'),
                                      SizedBox(width: 10,),
                                      Text(nomeNivel),

                                    ],
                                  ),
                                  Text('R\$  ${formatador.format(total)}')

                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                    children:[
                                      Text(nome),
                                      p.despesa !=  null?Text('Despesa ${p.despesa}'):Container()
                              ]



                                  ),
                                  Text(
                                    p.status,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              trailing: MergeSemantics(
                                child: CupertinoSwitch(
                                  value: p.isdespesa,
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      });
                }
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onRefresh() {
    //    return  _bloc.fetch(context);
  }

  @override
  void dispose() {
    _blocFor.dispose();
    _blocNivel.dispose();
    _blocAf.dispose();
    _blocAfPedidos.dispose();
    _contactStream.close();
    super.dispose();
  }


  _onClickDetalhe(Af c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.code.toString(), AfDetalhe(c)));
  }

  void _onSimpleSearch2Changed(String value) {
    if(busca == 1){
      List<Af> foundContacts = _allContacts
          .where((Af contact) =>
      contact.status
          .toLowerCase().indexOf(value.toLowerCase()) > -1)
          .toList();
      this._contactStream.add(foundContacts);
    }
    if(busca == 2){
      List<Af> foundContacts = _allContacts
          .where((Af contact) =>
      contact.code.toString()
          .toLowerCase().indexOf(value.toLowerCase()) > -1)
          .toList();
      this._contactStream.add(foundContacts);
    }
    if(busca == 3){
      List<Af> foundContacts = _allContacts
          .where((Af contact) =>
      contact.status
          .toLowerCase().indexOf(value.toLowerCase()) > -1)
          .toList();
      this._contactStream.add(foundContacts);
    }


  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }


}
