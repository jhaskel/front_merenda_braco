import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/consultaEscola.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/cosultaGeral.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/utils/app_colors.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:provider/provider.dart';

class ConsultaPage extends StatefulWidget {
  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  List<UnidadeEscolar> listEscolas;
  int idEscola = 0;
  int atual;
  bool _isLoading = true;


  iniciaBloc() {
    Provider.of<EscolaBloc>(context, listen: false).fetch(context).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    final bloc = Provider.of<EscolaBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      listEscolas = bloc.lista;

    var map1 = listEscolas.map((e) => e.alias).toSet().toList();
    var map2 = listEscolas.map((e) => e.id).toSet().toList();
    print('ma1 $map1');
    print('ma2 $map2');
    var list1 = ['Todas'];
    var list2 = [0];
    for (var x in map1) {
      list1.add(x);
    }
    for (var x in map2) {
      list2.add(x);
    }
    print('ZZZz $idEscola');

    return Column(
      children: [
        Container(
          height: 60,
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list1.length,
              itemBuilder: (context, index) {
                return Center(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: MaterialButton(
                          elevation: 5,
                          onPressed: () {
                            setState(() {
                              idEscola = list2[index];
                            });

                          },
                          color: list2[index] == idEscola
                              ? Colors.green
                              : Colors.grey,
                          hoverColor: AppColors.green,
                          highlightColor: AppColors.primaria,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0)),
                          child: Text(list1[index],
                              style: TextStyle(color: Colors.white)),
                        )));
              },
            ),
          ),
        ),
        Expanded(child: idEscola == 0
            ? consultaGeral()
            : consultaEscola()
        )
      ],
    );
  }
  ConsultaGeral consultaGeral() => ConsultaGeral();
  ConsultaEscola consultaEscola() => ConsultaEscola(idEscola);



}
