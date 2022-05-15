
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_page.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/cosultas_page.dart';

class TabsPage extends StatefulWidget {

  @override
  _TabsPageState createState() => new _TabsPageState();
}

class _TabsPageState extends State<TabsPage>
    with TickerProviderStateMixin {

  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();

      _tabs = [
        new Tab(text: 'Gastos com Merenda',),
        new Tab(text: 'Cardápio Escolar'),

      ];

      _pages = [
        ConsultaPage(),
        CardapioPage()
       // Container(child: Center(child: Text("Em Breve")),),

      ];

   _initTabs();
  }
  _initTabs() async {
    _controller = TabController(length:  _tabs.length, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
       title: Text("Comunidade"),
      ),
      body: _body(),

    );


  }

  _body() {
    double altura = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            labelColor: Theme.of(context).accentColor,
            indicatorColor: Theme.of(context).accentColor,
          ),
          new SizedBox.fromSize(
            size:  Size.fromHeight(altura-140),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
