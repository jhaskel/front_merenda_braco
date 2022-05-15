import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:merenda_escolar/core/bloc/afPedidos_bloc.dart';
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/core/bloc/almoxarifado_bloc.dart';
import 'package:merenda_escolar/core/bloc/cardapio_bloc.dart';
import 'package:merenda_escolar/core/bloc/cart_bloc.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/compras_bloc.dart';
import 'package:merenda_escolar/core/bloc/config_bloc.dart';
import 'package:merenda_escolar/core/bloc/contabilidade_bloc.dart';
import 'package:merenda_escolar/core/bloc/entrega_bloc.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/itens_bloc.dart';
import 'package:merenda_escolar/core/bloc/licitacao_bloc.dart';
import 'package:merenda_escolar/core/bloc/nivel_bloc.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/core/bloc/pnae_bloc.dart';
import 'package:merenda_escolar/core/bloc/produto_bloc.dart';
import 'package:merenda_escolar/core/bloc/setor_bloc.dart';
import 'package:merenda_escolar/core/bloc/unidade_bloc.dart';
import 'package:merenda_escolar/core/bloc/usuario_bloc.dart';
import 'package:merenda_escolar/pages/comunidade/home_comunidade.dart';
import 'package:merenda_escolar/pages/login/login_page.dart';
import 'package:merenda_escolar/utils/bloc/bloc.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:merenda_escolar/utils/bloc/bloc_afs.dart';
import 'package:merenda_escolar/utils/bloc/bloc_pedido.dart';
import 'package:merenda_escolar/utils/bloc/bloc_produto.dart';
import 'package:merenda_escolar/utils/bloc/bloc_produtos.dart';
import 'package:provider/provider.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}
void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('PASSOU');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PagesModel(),
        )
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PagesModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => NivelBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => UnidadeBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProdutoBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => FornecedorBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => CategoriaBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => PnaeBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsuarioBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => SetorBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => EscolaBloc(),
        ),


        ChangeNotifierProvider(
          create: (context) => EstoqueBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => PedidoBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => ComprasBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => LicitacaoBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => AfBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => ItensBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => AlmoxarifadoBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => AfPedidoBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => CardapioBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => ContabilidadeBloc(),
        ),

        ChangeNotifierProvider(
          create: (context) => EntregaBloc(),
        ),





      ],
      child: BlocProvider(
          blocs: [
            Bloc((i) => BlocController()),
            Bloc((i) => BlocProduto()),
            Bloc((i) => BlocProdutos()),
            Bloc((i) => BlocPedido()),
            Bloc((i) => BlocAf()),
            Bloc((i) => BlocAfs()),

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
          //  home: LoginPage(),
           home: LoginPage(),
            theme: _theme(context),
          )),
    );


  }

  _theme(context) {
    AppModel app = AppModel.get(context, listen: true);
    bool admin = app.user == null || app.user.isGerente();
    return admin ? _themeAdmin() : _themeAdmin();
  }

  _themeUser() {
    return ThemeData(
      fontFamily: "Raleway",
      primaryColor: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.blue[600],
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: AppColors.blue,
          fontSize: 12,
        ),
      ),
    );
  }

  _themeAdmin() {
    return ThemeData(
      fontFamily: "Raleway",
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.blue[600],

    );
  }
}
