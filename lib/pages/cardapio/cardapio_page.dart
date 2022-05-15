import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/cardapio_bloc.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_add.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_listview.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/utils/bloc/bloc.dart';



class CardapioPage extends StatefulWidget {


  @override
  _CardapioPageState createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Cardapio> listCardapio;
  List<UnidadeEscolar> listEscolas;
  bool buscando = true;
  bool _isLoading = true;
  bool _isLoadingEscolas = true;


  iniciaBloc() {
   Provider.of<EscolaBloc>(context, listen: false).fetch(context).then((_) {
    setState(() {
      _isLoadingEscolas = false;
    });

    });
    Provider.of<CardapioBloc>(context, listen: false).fetch(context).then((_) {
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
    final blocEscolas = Provider.of<EscolaBloc>(context);
    final bloc = Provider.of<CardapioBloc>(context);

    if (blocEscolas.lista.length == 0 && _isLoadingEscolas) {
      return Center(child: CircularProgressIndicator());
    } else if(blocEscolas.lista.length == 0 && !_isLoadingEscolas){
    return Center(child: Text('Não foi possível buscar os dados!'),);

    }
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading ){
    return Scaffold(
      key: _scaffoldKey,
      body: BreadCrumb(
          actions: [
            AddButton(
              onPressed: () => _onClickAdd(),
            )
          ],
          child: Center(child: Text("Sem registros",style: AppTextStyles.heading40,))
      ),
    );



    }else

      listCardapio = bloc.lista;
      listEscolas = blocEscolas.lista;

    return Scaffold(
      key: _scaffoldKey,


      body:BreadCrumb(
        child: _admin(listCardapio,listEscolas),
        actions: [
          AddButton(
            onPressed: () => _onClickAdd(),
          )
        ],
      ),


      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Container(),
      ),
    );
  }

  _admin(List<Cardapio> cardapio, List<UnidadeEscolar> listEscolas) {
    return CardapioListView(listCardapio,listEscolas);
  }

  _onClickAdd() {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('Nivel Escolar', CardapioAdd()));
  }



}