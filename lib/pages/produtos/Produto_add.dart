import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:validadores/Validador.dart';

class ProdutoAdd extends StatefulWidget {
  Produto produto;
  ProdutoAdd({this.produto});
  @override
  _ProdutoAddState createState() => _ProdutoAddState();
}

class _ProdutoAddState extends State<ProdutoAdd> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "produto_form");

  Produto get produto =>widget.produto;
  Color cor = Colors.white;

  var _showProgress = false;
  final tNome = TextEditingController();
  final tAlias = TextEditingController();
  final tUnidade = TextEditingController();


  @override
  void initState() {
    super.initState();
    if(produto !=null){
      tNome.text = produto.nome;
      tAlias.text = produto.alias;
      tUnidade.text = produto.unidade;
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: produto!=null ?AppBar(title: Text("Editar ${produto.alias}"),centerTitle: true,):null,

  body: BreadCrumb(
    child: _body(),
  )
);

  }

  _body() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  produto !=null
                      ? Text(
                    "Editar  Produto",
                    style: Theme.of(context).textTheme.headline5,
                  )
                  :Text(
                    "Cadastro de Produtos",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome do produto',
                    maxLines: 4,
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Alias',
                    hint: 'feijão, arrroz....',
                    controller: tAlias,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Unidade',
                    hint: 'kg, pct, und',
                    controller: tUnidade,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),


                  SizedBox(
                    height: 20,
                  ),



                  Divider(
                    height: 10.0,
                  ),
                  AppButton(
                    "Cadastrar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }




  _onClickSalvar() async {
   print("chegou");
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });
      var hoje = DateTime.now().toIso8601String();

      // Cria o usuario
      var produ = produto ?? Produto();

      produ.nome = tNome.text;
      produ.alias = tAlias.text;
      produ.unidade = tUnidade.text;

      ApiResponse<bool> response = await ProdutoApi.save(context, produ);

      if (response.ok) {
        tNome.clear();
        tAlias.clear();
        tUnidade.clear();
        alert(context, "Produto salvo com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });


      print("Fim.");
    }
  }
}
