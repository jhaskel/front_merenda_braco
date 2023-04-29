import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/nivel_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_detalhe.dart';
import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class OrdemPage extends StatefulWidget {
  @override
  _OrdemPageState createState() => _OrdemPageState();
}

class _OrdemPageState extends State<OrdemPage> {

  Usuario get user => AppModel.get(context).user;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  List<Fornecedor> fornecedors;
  ScrollController _controller = ScrollController();
  List<Nivel> Nivell;
  List<Af> afs;
  int busca = 1;
  bool _isLoadingFor = true;
  bool _isLoadingNivel = true;
  bool _isLoadingAf = true;
  List<AfPedido> afpedidos;
  String nomeNivel;


  iniciaBloc() {
    Provider.of<FornecedorBloc>(context, listen: false).fetch(context).then((
        _) {
      setState(() {
        _isLoadingFor = false;
      });
    });

    Provider.of<NivelBloc>(context, listen: false).fetch(context).then((_) {
      setState(() {
        _isLoadingNivel= false;
      });});

    Provider.of<AfBloc>(context, listen: false)
        .fetchStatus(context,Status.ordemProcessada)
        .then((value) {
      setState(() {
        _isLoadingAf = false;

      });
    });
  }


  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:BreadCrumb(
        child:  _body(),
      ),
    );
  }



  _body() {
    final blocFor = Provider.of<FornecedorBloc>(context);
    final blocNivel = Provider.of<NivelBloc>(context);
    final blocAf = Provider.of<AfBloc>(context);

    if (_isLoadingFor || _isLoadingAf || _isLoadingNivel) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Fornecedor> listFor = blocFor.lista;
    List<Af> listAfsSem = blocAf.listOrdem;
    List<Nivel> listNiveis = blocNivel.lista;
    List<Af> listAfs = listAfsSem
        .where((element) => element.isativo == true)
        .toList();


    if (listAfs.isEmpty || listNiveis.isEmpty || listFor.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextError("Não foram encontrados nenhum registro!"),
          ],
        ),
      );
    }


    return Container(
        child: _admin(listAfs, listFor, listNiveis));

  }

  _admin(List<Af> lisItens, List<Fornecedor> listFor,
      List<Nivel> listNiveis) {

    print(lisItens.length);
    print(listFor.length);
    print(listNiveis.length);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Scrollbar(
        controller: _controller,
        isAlwaysShown: true,
        showTrackOnHover: true,
        thickness: 10,
        radius: Radius.circular(15),
        child: ListView.builder(
            controller: _controller,
            itemCount: lisItens.length,
            itemBuilder: (context, index) {
              Af p = lisItens[index];
              var filtro = listFor
                  .where((element) => element.id == p.fornecedor).toSet()
                  .toList();
              var nome = filtro.map((e) => e.nome).first;

              var filtroNivel = listNiveis
                  .where((element) => element.id == p.nivel)
                  .toList();

             var nomeNivel = filtroNivel.map((e) => e.nome).first;
             DateTime crea = DateTime.parse(p.createdAt);

              return _cardProduto(p, crea, nomeNivel, nome);
            }),

      ),
    )
    ;
  }

  _cardProduto(Af p, DateTime crea, String nomeNivel, String nome) {



    return Column(
      children: [
        ListTile(
          onTap: () {
            _onClickDetalhe(p);
          },
          leading: Container(
            color: p.licitacao!=2?Colors.green:Colors.blue,
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
          trailing: Icon(Icons.arrow_forward_ios,size: 20,),

        ),
        Divider(),
      ],
    );
  }





  _onClickDetalhe(Af c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.code.toString(), AfDetalhe(c)));
  }




}
