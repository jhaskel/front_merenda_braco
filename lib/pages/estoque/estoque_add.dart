import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/produto_bloc.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoqueAdd/EstoqueAdd.dart';
import 'package:merenda_escolar/pages/estoque/estoqueAdd/estoqueAdd_api.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_detalhe.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:validadores/Validador.dart';

class EstoqueAdd extends StatefulWidget {
  Licitacao licitacao;
  Estoque estoque;

  EstoqueAdd({this.licitacao,this.estoque});

  @override
  _EstoqueAddState createState() => _EstoqueAddState();
}

class _EstoqueAddState extends State<EstoqueAdd> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "estoque_form");

  Color cor = Colors.white;
  Licitacao get licitacao => widget.licitacao;
  Estoque get estoque => widget.estoque;

  var _showProgress = false;
  final tCode = TextEditingController();
  final tCategoria = TextEditingController();
  final tFornecedor = TextEditingController();
  final tProduto = TextEditingController();
  final tQuantidade = TextEditingController();
  final tValor = TextEditingController();
  final tAgro = TextEditingController();
  final tAno = TextEditingController();

  int _radioAgroIndex = 0;
  int idCategoria;
  int idFornecedor;
  int idProduto;
  String nomeCategoria;
  String nomeFornecedor;
  String nomeProduto;
  String nomeProduto2;
  String processo;
  bool _isativo;
  EstoqueAd estoqueAd;

  Map<String, int> mapCategoria = new Map();
  Map<int, String> mapCategoria2 = new Map();
  List<Categoria> categoria;

  Map<String, int> mapFornecedor = new Map();
  Map<int, String> mapFornecedor2 = new Map();
  List<Fornecedor> fornecedor;

  Map<String, int> mapProduto = new Map();
  Map<int, String> mapProduto2 = new Map();
  List<Produto> produto;

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
        print("UIX $idFornecedor");
      });
      return mapFornecedor2[jk];
    }
  }

  getNomeProdutt(String data)  {
      var uni = produto.where((e) => e.alias==data).toList();
      setState(() {
        unidade = uni.first.unidade;
        nomeProduto2 = uni.first.nome;
      });

      print("kkl9 $unidade");
      print("kkl9 $nomeProduto2");

  }

  getNomeProduto(String data)  {
    print("kkl $data");
    if(produto !=null){
      var uni = produto.where((e) => e.id==int.parse(data)).toList();
      setState(() {
        unidade = uni.first.unidade;
        nomeProduto2 = uni.first.nome;
      });
    }

    print("kkl $unidade");
    print("kkl $nomeProduto2");
    int jk = int.parse(data);

    if ( mapProduto2.containsKey(jk)) {

      setState(() {
        idProduto = jk;
      });
      return mapProduto2[jk];
    }

  }


  @override
  void initState() {
    if (estoque != null) {
       tCode.text = estoque.code.toString();
       tCategoria.text = estoque.categoria.toString();
       tFornecedor.text = estoque.fornecedor.toString();
       tProduto.text = estoque.produto.toString();
       tQuantidade.text = estoque.quantidade.toString();
       tValor.text = estoque.valor.toString();
      _isativo = estoque.isativo;
       _radioAgroIndex = getAgroInt(estoque);

    }


    Provider.of<ProdutoBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        setState(() {
          produto=value;
          for (var gh in value) {
            mapProduto.putIfAbsent(gh.alias, () => gh.id);
          }

          for (var gh in value) {
            mapProduto2.putIfAbsent(gh.id, () => gh.alias);
          }
        });
      });
    });


    Provider.of<CategoriaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        for (var gh in value) {
          mapCategoria.putIfAbsent(gh.nome, () => gh.id);
        }
        print('mapCategoria${mapCategoria}');

        for (var gh in value) {
          mapCategoria2.putIfAbsent(gh.id, () => gh.nome);
        }
        print('mapCategoria2${mapCategoria2}');
      });
    });

    Provider.of<FornecedorBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        setState(() {
          for (var gh in value) {
            mapFornecedor.putIfAbsent(gh.nome, () => gh.id);
          }

          for (var gh in value) {
            mapFornecedor2.putIfAbsent(gh.id, () => gh.nome);
          }
        });
      });
    });

    if(estoque !=null){
      estoqueAd = EstoqueAd(
        id: estoque.id,
        produto: estoque.produto,
        setor: estoque.setor,
        code: estoque.code,
        alias: estoque.alias,
        quantidade: estoque.quantidade,
        unidade: estoque.unidade,
        categoria: estoque.categoria,
        licitacao: estoque.licitacao,
        fornecedor: estoque.fornecedor,
        agrofamiliar: estoque.agrofamiliar,
        valor: estoque.valor,
        ano: estoque.ano,
        createdAt: estoque.createdAt,
        modifiedAt: estoque.modifiedAt,
        isativo: estoque.isativo,

      );
    }

    super.initState();
  }

  String unidade;


  @override
  Widget build(BuildContext context) {
    print("ISATU $_isativo");

    return BreadCrumb(child: _body());
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
                    "Cadastro de Produtos na Licitação",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  estoque !=null? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MergeSemantics(
                        child: CupertinoSwitch(
                          value: _isativo,
                          onChanged: (bool newValue) {
                            setState(() {
                              _isativo = newValue;
                            });

                          },
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('Ativo')
                    ],

                  ):Container(),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Container(
                          width: 120,
                          child: AppTFF(
                            label: 'Código',
                            hint: 'código do estoque',
                            controller: tCode,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: false);
                            },
                          )),
                      Container(
                          width: 200,
                          child: AppTFF(
                            label: 'Quantidade',
                            hint: 'Ex.: 60',
                            controller: tQuantidade,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: false);
                            },
                          )),
                      Container(
                          width: 200,
                          child: AppTFF(
                            label: 'Valor',
                            hint: 'Ex.:2.36',
                            controller: tValor,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: false);
                            },
                          )),
                    ],
                  ),
                 estoque== null? Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        showSearchBox: true,
                        mode: Mode.BOTTOM_SHEET,
                        showSelectedItem: true,
                        items: mapProduto.keys.toList(),
                        label: "Produto",
                        onChanged: (String data) {
                          setState(() {
                            idProduto = mapProduto[data];
                            nomeProduto = data;
                            getNomeProdutt(data);

                          });
                        },
                        selectedItem: estoque == null ? 'Selecione um Produto':getNomeProduto(tProduto.text)
                      //  selectedItem: 'Selecione um Produto'
                    ),

                  ):Container(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapCategoria.keys.toList(),
                        label: "Categoria",
                        onChanged: (String data) {
                          setState(() {
                            idCategoria = mapCategoria[data];
                            nomeCategoria = data;

                          });
                        },
                        selectedItem: estoque == null ? 'Selecione uma Categoria':getNomeCategoria(tCategoria.text)
                       // selectedItem: 'Selecione uma Categoria'
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapFornecedor.keys.toList(),
                        label: "Fornecedor",
                        onChanged: (String data) {
                          setState(() {
                            idFornecedor = mapFornecedor[data];
                            nomeFornecedor = data;
                            print("nomefor $nomeFornecedor");
                          });
                        },
                        selectedItem: estoque == null ? 'Selecione um Fornecedor':getNomeFornecedor(tFornecedor.text)
                       // selectedItem: 'Selecione um Fornecedor'
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Agricultura Familiar?'),
                      ),
                      Container(
                        width: 200,
                        child: _radioAgro(),
                      )
                    ],
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

  bool _getAgro() {
    switch (_radioAgroIndex) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
    }
  }

  _radioAgro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: Colors.green,
          value: 0,
          groupValue: _radioAgroIndex,
          onChanged: _onClickAgro,
        ),
        Text(
          "Não",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          activeColor: Colors.green,
          value: 1,
          groupValue: _radioAgroIndex,
          onChanged: _onClickAgro,
        ),
        Text(
          "Sim",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickAgro(int value) {
    setState(() {
      _radioAgroIndex = value;
    });
  }


  getAgroInt(Estoque estoque) {
    switch (estoque.agrofamiliar) {
      case true:
        return 1;
      default:
        return 0;
    }
  }


  _onClickSalvar() async {

    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();
      var bloc = Provider.of<EstoqueBloc>(context,listen: false);

      String quant = tQuantidade.text;
      double quantidade;
      if (quant.contains(',')) {
        quant = quant.replaceAll(".", "");
        quant = quant.replaceAll(",", ".");
        quantidade = double.parse(quant);
      } else {
        quantidade = double.parse(quant);
      }
      String valor1 = tValor.text;
      double valor;
      print("000 $valor1");
      if (valor1.contains(',')) {
        print("001 $valor1");
        valor1 = valor1.replaceAll(".", "");
        print("002 $valor1");
        valor1 = valor1.replaceAll(",", ".");
        print("003 $valor1");
        valor = double.parse(valor1);
        print("004 $valor");
      } else {
        print("1111 $valor");
        valor = double.parse(valor1);
      }
      // Cria o usuario
    var produ = estoqueAd ?? EstoqueAd();
        produ.produto= idProduto;
        produ.setor =1;
        produ.code = int.parse(tCode.text);
        produ.alias = estoque==null?nomeProduto:estoqueAd.alias;
        produ.nomeproduto = nomeProduto2;
        produ.quantidade = quantidade;
        produ.unidade = estoque ==null ?unidade:estoqueAd.unidade;
        produ.categoria = idCategoria;
        produ.licitacao = licitacao.id;
        produ.processo = licitacao.processo;
        produ.fornecedor = idFornecedor;
        produ.agrofamiliar = _getAgro();
        produ.valor = valor;
        produ.ano = licitacao.ano;
        produ.isativo = estoque == null ? true :_isativo;
        produ.createdAt = hoje;
        produ.modifiedAt = hoje;

      ApiResponse<bool> response = await EstoqueAddApi.save(context, produ);

      if (response.ok) {
        tCode.clear();
        tQuantidade.clear();
        tValor.clear();
        bloc.fetchLicitacao(context, widget.licitacao.id);
        print("SUCESSO");

      /*  alert(context, "Estoque salvo com sucesso", callback: () {_onClickRetorna();

        });*/
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });


      print("Fim.");
    }
  }
  _onClickRetorna() {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo('${licitacao.processo}', LicitacaoDetalhe(licitacao: licitacao,)),replace: true);
  }
}
