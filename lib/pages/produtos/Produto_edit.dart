
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:provider/provider.dart';

import 'package:validadores/Validador.dart';

class ProdutoEdit extends StatefulWidget {
  final Produto produto;

  ProdutoEdit({this.produto}) : super();

  @override
  _ProdutoEditState createState() => _ProdutoEditState();
}

class _ProdutoEditState extends State<ProdutoEdit> {
  Produto get produto => widget.produto;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "produto_form");
  Color cor = Colors.white;

  var _showProgress = false;
  final tCode = TextEditingController();
  final tNome = TextEditingController();
  final tAlias = TextEditingController();
  final tCategoria = TextEditingController();
  final tFornecedor = TextEditingController();
  final tImage = TextEditingController();
  final tUnidade = TextEditingController();

  int idCategoria;
  int idFornecedor;
  String nomeCategoria;
  String nomeFornecedor;
  Map<String, int> mapCategoria = new Map();
  Map<int, String> mapCategoria2 = new Map();
  List<Categoria> categoria;

  Map<String, int> mapFornecedor = new Map();
  Map<int, String> mapFornecedor2 = new Map();

  List<Fornecedor> fornecedor;
  bool _isativo;

  getNomeCategoria(String data) {
    int jk = int.parse(data);
    if (mapCategoria2.containsKey(jk)) {
      setState(() {
        idCategoria = jk;
      });
      return mapCategoria2[jk];
    }
  }

  getNomeFornecedor(String data) {
    int jk = int.parse(data);
    if (mapFornecedor2.containsKey(jk)) {
      setState(() {
        idFornecedor = jk;
      });
      return mapFornecedor2[jk];
    }
  }

  @override
  void initState() {
 Provider.of<CategoriaBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
     for (var gh in value) {
          mapCategoria.putIfAbsent(gh.nome, () => gh.id);
        }
        print('mapCategoria${mapCategoria}');

        for (var gh in value) {
          mapCategoria2.putIfAbsent(gh.id, () => gh.nome);
        }
        print('mapCategoria2${mapCategoria2}');

    });});





 Provider.of<FornecedorBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
     setState(() {
        for (var gh in value) {
          mapFornecedor.putIfAbsent(gh.nome, () => gh.id);
        }

        for (var gh in value) {
          mapFornecedor2.putIfAbsent(gh.id, () => gh.nome);
        }
      });


    });  });




    if (produto != null) {
      tNome.text = produto.nome;
      tAlias.text = produto.alias;
      tUnidade.text = produto.unidade;
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    tCategoria.text = nomeCategoria;
    tFornecedor.text = nomeFornecedor;
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.alias),
        centerTitle: true,
      ),
      body: _body(),
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
                  Text(
                    "Cadastro de Produtos",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Código',
                    hint: 'código do produto',
                    controller: tCode,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da fornecedor',
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        //showSelectedItem: true,
                        items: mapCategoria.keys.toList(),
                        label: "Categoria",
                        onChanged: (String data) {
                          setState(() {
                            idCategoria = mapCategoria[data];
                            nomeCategoria = data;
                          });
                        },
                        selectedItem: getNomeCategoria(tCategoria.text)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        //showSelectedItem: true,
                        items: mapFornecedor.keys.toList(),
                        label: "Fornecedor",
                        onChanged: (String data) {
                          setState(() {
                            idFornecedor = mapFornecedor[data];
                            nomeFornecedor = data;
                          });
                        },
                        selectedItem: getNomeFornecedor(tFornecedor.text)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Imagem',
                    hint: 'endereço da internet',
                    controller: tImage,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),


                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Agricultura Familiar?'),
                      ),

                    ],
                  ),
                  Divider(
                    height: 10.0,
                  ),
                  AppButton(
                    "Editar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }




  _onClickSalvar() async {
    final blocPage = Provider.of<PageBloc>(context);
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
        tCode.clear();
        tNome.clear();
        tAlias.clear();
        tImage.clear();
        tUnidade.clear();


        alert(context, "Produto salvo com sucesso", callback: () {
          Navigator.of(context).pop();
        });
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;

      });
      blocPage.setPage(AppPages.produto);
      print("Fim.");
    }
  }


}
