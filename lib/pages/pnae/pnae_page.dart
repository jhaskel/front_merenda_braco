
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';
import 'package:merenda_escolar/pages/pnae/Pnae_bloc.dart';
import 'package:merenda_escolar/pages/pnae/pnae_add.dart';
import 'package:merenda_escolar/pages/pnae/pnae_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class PnaePage extends StatefulWidget {
  @override
  _PnaePageState createState() => _PnaePageState();
}

class _PnaePageState extends State<PnaePage> {

  Usuario get user => AppModel.get(context).user;
  final _bloc = PnaeBloc();
  List<Pnae> pnaes;

  @override
  void initState() {
      _bloc.fetch(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 

      return StreamBuilder(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return TextError("Não foi possível buscar os dadoss");
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Pnae> pnae = snapshot.data;
            if(pnae.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextError("Não foram encontrados nenhum registro!"),
                    AddButton(
                      onPressed: ()=>_onClickAdd(),
                    )
                  ],

                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: _admin(pnae),
            );



          }
      );
    

  }
 

  _admin(List<Pnae> pnae) {
    return Scaffold(
      body: BreadCrumb(
        child:PnaeListView(pnae),
        actions: [
          AddButton(
            onPressed: ()=>_onClickAdd(),
          )
        ],
      ),
    );
  }

  // Adicionar novo carro
  _onClickAdd() {
    PagesModel.get(context).push(PageInfo("Pnae",PnaeAdd()));
  }

  Future<void> _onRefresh() {
      return  _bloc.fetch(context);

  }
}

