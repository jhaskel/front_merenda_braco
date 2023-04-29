import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/af/ordem_tab.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/pedido/pedido_page.dart';
import 'package:merenda_escolar/pages/usuarios/meus_dados_page.dart';
import 'package:merenda_escolar/utils/bloc/bloc.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  GlobalKey _menuState = GlobalKey();


  Size get size => MediaQuery.of(context).size;
  final BlocController bloc = BlocProvider.getBloc<BlocController>();
  final BlocAf blocAf = BlocProvider.getBloc<BlocAf>();

  iniciaBloc() {
    Provider.of<PedidoBloc>(context, listen: false).fetchCheck(context, false);
    Provider.of<AfBloc>(context, listen: false).fetchSetor(context,1);
  }

  Usuario get user => AppModel.get(context).user;
  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/imgs/brasao.png',
        height: 50,
      ),
      title: Text(
        "Merenda Escolar ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      trailing: _right(),
    );
  }

  _right() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "${user?.nome}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          child: CircleAvatar(
            backgroundImage: user.urlFoto != null
                ? NetworkImage("${user.urlFoto}")
                : AssetImage('assets/imgs/user.png'),
          ),
          onTap: () {
            // abre o popup menu
            dynamic state = _menuState.currentState;
            state.showButtonMenu();
          },
        ),
        PopupMenuButton<String>(
          key: _menuState,
          padding: EdgeInsets.zero,
          onSelected: (value) {
            _onClickOptionMenu(context, value);
          },
          child: Icon(
            Icons.arrow_drop_down,
            size: 28,
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context) => _getActions(),
        ),
        SizedBox(
          width: 20,
        ),
        !user.isEmpenho() && !user.isUnidade() ?_cart():Container(),
        !user.isEmpenho() && !user.isUnidade() ?_ordemNova():Container(),
        user.isEmpenho() && !user.isUnidade() ?_ordemAutorizada():Container(),
        !user.isEmpenho() && !user.isUnidade()?_ordemEmpenhada():Container(),


      ],
    );
  }

  _getActions() {
    return <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: "meus_dados",
        child: Text("Meus dados"),
      ),
      PopupMenuItem<String>(
        value: "logout",
        child: Text("Logout"),
      ),
    ];
  }

  void _onClickOptionMenu(context, String value) {
    if ("logout" == value) {
      logout(context);
    } else if ("meus_dados" == value) {
      Usuario user = AppModel.get(context).user;
      PagesModel.get(context).push(PageInfo("Meus Dados", MeusDadosPage(user)));
    } else {}
  }

  Widget _cart() {
    final blocPedido = Provider.of<PedidoBloc>(context);
    var k = blocPedido.listaCount;
    var kx = k.toString();
    return kx != "0"
        ? InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: badges.Badge(
                position: BadgePosition.topEnd(top: -6, end: 0),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: Text(kx, style: TextStyle(color: Colors.white)),
                child: Icon(Icons.shopping_cart,size: 30,),
              ),
            ),
            onTap: () {
              PagesModel.get(context).push(PageInfo("Pedidos", PedidoPage()));
            },
          )
        : Icon(Icons.shopping_cart_outlined);
  }
  Widget _ordemNova() {
    final blocAf = Provider.of<AfBloc>(context);
    var k = blocAf.itensNovos;
    var kx = k.toString();
    return kx != "0"
        ? InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: badges.Badge(
          position: BadgePosition.topEnd(top: -6, end: 0),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          badgeContent: Text(kx, style: TextStyle(color: Colors.white)),
          child: Icon(Icons.notifications_on_rounded,size: 30,),
        ),
      ),
      onTap: () {
        PagesModel.get(context).push(PageInfo("Ordens", OrdemTab()));
      },
    )
        : Icon(Icons.notifications);
  }
  Widget _ordemAutorizada() {
    final blocAf = Provider.of<AfBloc>(context);
    var k = blocAf.itensAutorizados;
    var kx = k.toString();
    return kx != "0"
        ? InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: badges.Badge(
          position: BadgePosition.topEnd(top: -6, end: 0),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          badgeContent: Text(kx, style: TextStyle(color: Colors.white)),
          child: Icon(Icons.check_circle,size: 30,),
        ),
      ),
      onTap: () {
        PagesModel.get(context).push(PageInfo("Ordens", OrdemTab()));
      },
    )
        : Icon(Icons.check);
  }
  Widget _ordemEmpenhada() {
    final blocAf = Provider.of<AfBloc>(context);
    var k = blocAf.itensEmpenhado;
    var kx = k.toString();
    return kx != "0"
        ? InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: badges.Badge(
          position: BadgePosition.topEnd(top: -6, end: 0),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          badgeContent: Text(kx, style: TextStyle(color: Colors.white)),
          child: Icon(Icons.bookmark,size: 30,),
        ),
      ),
      onTap: () {
        PagesModel.get(context).push(PageInfo("Ordens", OrdemTab()));
      },
    )
        : Icon(Icons.bookmark);
  }

}
