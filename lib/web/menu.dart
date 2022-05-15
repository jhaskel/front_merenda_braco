import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merenda_escolar/pages/af/ordem_page.dart';
import 'package:merenda_escolar/pages/af/ordem_tab.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado_page.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_page.dart';

import 'package:merenda_escolar/pages/categorias/categoria_page.dart';
import 'package:merenda_escolar/pages/compras/compras_page.dart';
import 'package:merenda_escolar/pages/config/config_page.dart';
import 'package:merenda_escolar/pages/default_page.dart';
import 'package:merenda_escolar/pages/escolaPage.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_page.dart';
import 'package:merenda_escolar/pages/gerente/principal.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_page.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_page.dart';
import 'package:merenda_escolar/pages/pedido/pedido_page.dart';
import 'package:merenda_escolar/pages/pnae/pnae_page.dart';
import 'package:merenda_escolar/pages/produtos/Produto_page.dart';
import 'package:merenda_escolar/pages/relatorios/relatorio_page.dart';
import 'package:merenda_escolar/pages/sobre/sobre_page.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_page.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_datatable_page.dart';


class ItemMenu {
  String title;
  IconData icon;
  Widget page;
  bool selected = false;

  ItemMenu(this.title, this.icon, this.page);
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ItemMenu> menus = [];
  Usuario get user => AppModel.get(context).user;
  Key key;


  @override
  void initState() {
    super.initState();

     menus.add(ItemMenu("Home", FontAwesomeIcons.home, DefaultPage()));


    if(user.isMaster()){
      menus.add(ItemMenu("Pedidos", FontAwesomeIcons.list, PedidoPage()));
      menus.add(ItemMenu("Ordens", FontAwesomeIcons.perbyte, OrdemTab()));
      menus.add(ItemMenu("Licitações", FontAwesomeIcons.angry, LicitacaoPage()));
      menus.add(ItemMenu("Nivel escolar", FontAwesomeIcons.archway, NivelPage()));
      menus.add(ItemMenu("Escolas", FontAwesomeIcons.school, UnidadeEscolarPage()));
      menus.add(ItemMenu("Categorias", FontAwesomeIcons.clipboardList, CategoriaPage()));
      menus.add(ItemMenu("Fonecedores", FontAwesomeIcons.hotel, FornecedorPage()));
      menus.add(ItemMenu("Itens", FontAwesomeIcons.nutritionix, ProdutoPage()));
      menus.add(ItemMenu("Pnae", FontAwesomeIcons.rainbow, PnaePage()));
      menus.add(ItemMenu("Usuários", FontAwesomeIcons.user, UsuariosPage()));
      menus.add(ItemMenu("Config", FontAwesomeIcons.cog, ConfigPage()));
      menus.add(ItemMenu("Relatórios", FontAwesomeIcons.laptop, RelatorioPage(user)));
      menus.add(ItemMenu("Sobre", FontAwesomeIcons.fill, SobrePage()));
    }

    if(user.isGerente()){

      menus.add(ItemMenu("Pedidos", FontAwesomeIcons.list, PedidoPage()));
      menus.add(ItemMenu("Ordens", FontAwesomeIcons.perbyte, OrdemTab()));
      menus.add(ItemMenu("Licitações", FontAwesomeIcons.angry, LicitacaoPage()));
      menus.add(ItemMenu("Nivel escolar", FontAwesomeIcons.archway, NivelPage()));
      menus.add(ItemMenu("Escolas", FontAwesomeIcons.school, UnidadeEscolarPage()));
      menus.add(ItemMenu("Categorias", FontAwesomeIcons.clipboardList, CategoriaPage()));
      menus.add(ItemMenu("Fonecedores", FontAwesomeIcons.hotel, FornecedorPage()));
      menus.add(ItemMenu("Itens", FontAwesomeIcons.nutritionix, ProdutoPage()));
      menus.add(ItemMenu("Pnae", FontAwesomeIcons.rainbow, PnaePage()));
      menus.add(ItemMenu("Cardápio", FontAwesomeIcons.bookmark, CardapioPage()));
      menus.add(ItemMenu("Usuários", FontAwesomeIcons.user, UsuariosPage()));
      menus.add(ItemMenu("Config", FontAwesomeIcons.cog, ConfigPage()));
      menus.add(ItemMenu("Relatórios", FontAwesomeIcons.laptop, RelatorioPage(user)));
      menus.add(ItemMenu("Sobre", FontAwesomeIcons.fill, SobrePage()));

    }
    if(user.isUnidade()){
      menus.add(ItemMenu("Estatisticas", FontAwesomeIcons.shoppingCart, EscolaPage()));
      menus.add(ItemMenu("Pedidos", FontAwesomeIcons.list, PedidoPage()));
     // menus.add(ItemMenu("Dispensa", FontAwesomeIcons.list, AlmoxarifadoPage(user)));
      menus.add(ItemMenu("Sobre", FontAwesomeIcons.fill, SobrePage()));

    }

    if(user.isEmpenho()){

      menus.add(ItemMenu("Sobre", FontAwesomeIcons.fill, SobrePage()));

    }

  }

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      itemCount: menus.length,
      itemBuilder: (context, index) {
        ItemMenu item = menus[index];
        return _itemMenu(item);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
  _itemMenu(ItemMenu item) {
    return Material(
      color: item.selected ? Theme.of(context).hoverColor : Colors.transparent,
      child: InkWell(
        onTap: () {
          PagesModel app = PagesModel.get(context);
          app.push(PageInfo(item.title, item.page), replace: true);

          setState(() {
            menus.forEach((item) => item.selected = false);
            item.selected = true;
          });
        },
        child: ListTile(
          leading: Icon(
            item.icon,size: 14,
            color: Colors.green,
          ),
          title: Text(
            item.title,
            style: TextStyle(
                fontWeight:
                item.selected ? FontWeight.bold : FontWeight.normal,fontSize: 13),
          ),
        ),
      ),
    );
  }
}
