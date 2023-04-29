import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/core/bloc/categoria_bloc.dart';
import 'package:merenda_escolar/core/bloc/compras_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/af/afAdd/Af.dart';
import 'package:merenda_escolar/pages/af/afAdd/af_api.dart';
import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/afPedido/afpedido_api.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd_api.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/compras/Compras.dart';
import 'package:merenda_escolar/pages/compras/compras_api.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:merenda_escolar/pages/pedido/pedidoAdd/PedidoAdd_api.dart';
import 'package:merenda_escolar/pages/pedido/pedido_page.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/pdf/pedidos_pdf.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PedidoDetalhe extends StatefulWidget {
  final Pedido pedido;
  final Usuario user;
  PedidoDetalhe({this.pedido, this.user});

  @override
  _PedidoDetalheState createState() => _PedidoDetalheState();
}

PedidoAdd pedidoAdd;

class _PedidoDetalheState extends State<PedidoDetalhe> {
  List<int> listFornecedores = [];
  List<String> nomeFornecedores = [];
  List<int> categorias = [];
  List<int> listNiveis = [];
  int idNivel;
  List<Compras> listItens = [];
  List<Fornecedor> ltFornecedores = [];
  List<Categoria> ltCategorias = [];
  Usuario get user => widget.user;
  ScrollController _controller = ScrollController();
  bool isRecebido;
  final tQuantidade = TextEditingController();
  var _showProgress = false;
  var _isLoading = true;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  double totalPedido = 0;
  int step;
  int currentStep = 0;
  int total = 0;
  int _itens = 0;
  int itensRecebidos = 0;
  Map<int, String> mapFornecedores = new Map();

  iniciaBloc() async {
    pedidoAdd = PedidoAdd(
      id: widget.pedido.id,
      total: widget.pedido.total,
      isaf: widget.pedido.isaf,
      isativo: widget.pedido.isativo,
      createdAt: widget.pedido.createdAt,
      escola: widget.pedido.escola,
      modifiedAt: widget.pedido.modifiedAt,
      status: widget.pedido.status,
      ischeck: widget.pedido.ischeck,
    );

    await Provider.of<FornecedorBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        ltFornecedores = value;
        for (var gh in value) {
          mapFornecedores.putIfAbsent(gh.id, () => gh.alias);
        }
      });
    });

    Provider.of<ComprasBloc>(context, listen: false)
        .fetchPedido(context, widget.pedido.id)
        .then((value) {
      setState(() {
        listItens = value;
        _isLoading = false;
        listItens = value;
        var x = listItens.map((e) => e.fornecedor).toSet().toList();
        var xy = listItens.map((e) => e.total).toList();
        listNiveis = listItens.map((e) => e.nivel).toSet().toList();

        totalPedido = xy.reduce((a, b) => a + b);
        var iteRecebido = listItens.where((e) => e.ischeck == true).toList();
        _itens = listItens.length;
        itensRecebidos = iteRecebido.length;
        print("ITENS $_itens");
        print("ITENRE $itensRecebidos");
        idNivel = listItens.first.nivel;
        for (var x in x) {
          listFornecedores.add(x);
        }
      });
    });
    await Provider.of<CategoriaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      ltCategorias = value.where((e) => e.isalimento == false).toList();

      setState(() {
        for (var gh in ltCategorias) {
          categorias.add(gh.id);
        }
      });
    });
  }

  @override
  void initState() {
    iniciaBloc();
    Provider.of<PedidoBloc>(context, listen: false).fetchCheck(context, false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _body(),
      bottomNavigationBar:
      !widget.pedido.isaf && _isLoading == false
          ? Container(
        width: MediaQuery.of(context).size.width,
        child: !user.isUnidade()
            ?MaterialButton(
            color: Colors.lightBlue,
            onPressed: () {
              _geraAf();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gerar Ordem',
                    style: AppTextStyles.titleBold,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'R\$ ${formatador.format(totalPedido)}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
        )
            :MaterialButton(
            color: Colors.lightBlue,
            onPressed: () {

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'R\$ ${formatador.format(totalPedido)}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            )
        )
        ,
      )
          : Container(child: MaterialButton(
          color: Colors.lightBlue,
          onPressed: () {

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'R\$ ${formatador.format(totalPedido)}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          )
      ),
      ),
    );
  }

  _body() {
    final bloc = Provider.of<ComprasBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      return BreadCrumb(
        actions: [
          PrintButton(
            onPressed: () {
              if (widget.pedido.isaf) {
                _onClickPdf(listItens);
              } else {
                alert(context, "Essa ordem ainda não foi autorizada");
              }
            },
          ),
        ],
        child: Stack(
          children: [
            _item(),
            _showProgress
                ? Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Aguarde....',
                      style: AppTextStyles.heading40,
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: step,
                      currentStep: currentStep,
                      stepSize: 10,
                      selectedColor: AppColors.secundaria,
                      unselectedColor: AppColors.grey,
                      padding: 0,
                      width: 150,
                      height: 150,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                    ),
                  ],
                ),
              ),
            )
                : Container()
          ],
        ),
      );
  }

  _item() {
    final blocFor = Provider.of<FornecedorBloc>(context);

    ltFornecedores = blocFor.lista;

    return LayoutBuilder(builder: (context, constraints) {
      double limite = 600.0;
      double tela = constraints.maxWidth;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Text(
                      'Produto',
                      style: AppTextStyles.titleBoldBlack,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(
                    'Uni',
                    style: AppTextStyles.titleBoldBlack,
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'Quant',
                    style: AppTextStyles.titleBoldBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
                tela > limite
                    ? Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'Valor',
                    style: AppTextStyles.titleBoldBlack,
                    textAlign: TextAlign.end,
                  ),
                )
                    : Container(),
                tela > limite
                    ? Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'Total',
                    style: AppTextStyles.titleBoldBlack,
                    textAlign: TextAlign.end,
                  ),
                )
                    : Container(),
                tela > limite
                    ? Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Text(
                    'For',
                    style: AppTextStyles.titleBoldBlack,
                    textAlign: TextAlign.center,
                  ),
                )
                    : Container(),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(
                    '#',
                    style: AppTextStyles.titleBoldBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RawScrollbar(
                controller: _controller,
                isAlwaysShown: true,
                thickness: 10,
                radius: Radius.circular(15),
                thumbColor: Colors.greenAccent,
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                      itemCount: listItens.length,
                      itemBuilder: (context, index) {
                        Compras i = listItens[index];
                        isRecebido = i.ischeck;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Text(i.alias),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text(i.unidade),
                                ),
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !widget.pedido.isaf
                                          ? IconButton(
                                          icon: Icon(Icons
                                              .indeterminate_check_box),
                                          onPressed: () {
                                            decrement(i);
                                          })
                                          : Container(),
                                      Text(
                                        i.quantidade.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                      !widget.pedido.isaf
                                          ? IconButton(
                                          icon: Icon(Icons.add_box),
                                          onPressed: () {
                                            increment(i);
                                          })
                                          : Container(),
                                    ],
                                  ),
                                ),
                                tela > limite
                                    ? Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Text(
                                    'R\$ ${formatador.format(i.valor)}',
                                    textAlign: TextAlign.end,
                                  ),
                                )
                                    : Container(),
                                tela > limite
                                    ? Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Text(
                                    'R\$ ${formatador.format(i.total)}',
                                    textAlign: TextAlign.end,
                                  ),
                                )
                                    : Container(),
                                tela > limite
                                    ? SizedBox(
                                  width: 5,
                                )
                                    : Container(),
                                tela > limite
                                    ? Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(right: 5),
                                    child: Text(
                                      mapFornecedores[i.fornecedor],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                                    : Container(),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: i.af == 0
                                  //se nao tiver af pode deletar]
                                      ? IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        showExcluir(context, i),
                                  )
                                  //se tiver af não pode mais deletar
                                      : widget.pedido.status !=
                                      Status.pedidoRealizado &&
                                      user.isUnidade()
                                      ? MergeSemantics(
                                    child: CupertinoSwitch(
                                      value: isRecebido,
                                      onChanged:
                                          (bool newValue) async {
                                        setState(() {
                                          isRecebido = newValue;
                                        });
                                        recebeProduto(newValue, i);
                                      },
                                    ),
                                  )
                                      : MergeSemantics(
                                    child: CupertinoSwitch(
                                      value: i.ischeck,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1)
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  increment(Compras c) async {
    setState(() {
      totalPedido = totalPedido + c.valor;
    });
    var quant = c.quantidade + 1;
    alteraQuantidade(c, quant, c.valor, true);
    var itee = pedidoAdd ?? PedidoAdd();
    itee.total = totalPedido;
    itee.ischeck = false;
    await PedidoAddApi.save(context, itee);
  }

  decrement(Compras c) async {
    setState(() {
      totalPedido = totalPedido - c.valor;
    });
    if (c.quantidade > 1) {
      var quant = c.quantidade - 1;
      alteraQuantidade(c, quant, c.valor, false);
      var itee = pedidoAdd ?? PedidoAdd();
      itee.total = totalPedido;
      itee.ischeck = false;
      await PedidoAddApi.save(context, itee);
    }
  }

  alteraQuantidade(Compras c, double quant, double valor, bool inc) async {
    var hoje = DateTime.now().toIso8601String();
    var itee = c ?? Compras();
    itee.id = c.id;
    itee.quantidade = quant;
    itee.total = inc ? c.total + valor : c.total - valor;
    await ComprasApi.save(context, itee);

    await iniciaBloc();

    var ped = pedidoAdd ?? PedidoAdd();
    ped.id = pedidoAdd.id;
    ped.total = totalPedido;
    ped.modifiedAt = hoje;
    itee.ischeck = false;
    await PedidoAddApi.save(context, ped);
  }


  Future<void> _geraAf() async {
    final blocPedido = Provider.of<PedidoBloc>(context, listen: false);
    var afbloc = Provider.of<AfBloc>(context, listen: false);

    //antigo
    AfAdd af;
    AfPedido afpedido;
    var codex = DateFormat("yyMMdd").format(DateTime.now());
    var lista = listFornecedores.toList();
    var niveis = listItens.map((e) => e.nivel);
    var nivel = [1];
    print("LIST NIVEl $nivel");
    setState(() {
      _showProgress = true;
      step = lista.length;
    });

    print(lista);
    idNivel = listItens.first.nivel;

  //  nivel.clear();
  //  nivel.add(0);

    for (var ni in nivel) {
      print("NIVel $ni");
      for (var forn in lista) {
        var tot = listItens
            .where((e) => e.fornecedor == forn)
            .where((w) => w.nivel == ni);
        var tot1 = tot.map((e) => e.total);
        var total = tot1.reduce((a, b) => a + b);

        var code = ('$codex$ni$forn');

        toast(context, 'Gerando Af ${code}...Aguarde!', duration: 5);

        var afp = afpedido ?? AfPedido();
        afp.af = int.parse(code);
        afp.pedido = widget.pedido.id;
        afp.total = total;
        afp.fornecedor = forn;
        afp.nivel = ni;
        afp.setor = widget.user.setor;
        AfPedidoApi.save(context, afp);

        var afs = af ?? AfAdd();
        afs.code = int.parse(code);
        afs.createdAt = DateTime.now().toIso8601String();
        afs.fornecedor = forn;
        afs.isenviado = false;
        afs.status = Status.ordemProcessada;
        afs.isativo = true;
        afs.nivel = ni;
        afs.setor = widget.user.setor;
        afs.isdespesa = false;

        ApiResponse<bool> response =  await AfAddApi.save(context, afs);
        if (response.ok) {
          afbloc.addItensNovos(1);
        }
        setState(() {
          currentStep++;
        });

        Compras itek;
        for (var ite in listItens) {
          itek = ite;
          if (ite.fornecedor == forn) {
            var itee = itek ?? Compras();
            itee.id = itek.id;
            itee.af = int.parse(code);
            print(itee);
            ComprasApi.save(context, itee);
          }
        }

        print('${codex}${forn} - ${total}');
      }
    }
    blocPedido.decQuant(1);

    print("KLKKLKLKLKL");
    var afs = pedidoAdd ?? PedidoAdd();
    afs.status = Status.pedidoProcessado;
    afs.isaf = true;
    afs.ischeck = true;
    await PedidoAddApi.save(context, afs);
    setState(() {
      _showProgress = false;
    });
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo("pedidos", PedidoPage()), replace: true);
  }
  Future<void> _geraAf2() async {
    final blocPedido = Provider.of<PedidoBloc>(context, listen: false);
    var afbloc = Provider.of<AfBloc>(context, listen: false);

    //antigo
    AfAdd af;
    AfPedido afpedido;
    var codex = DateFormat("yyMMdd").format(DateTime.now());
    var lista = listFornecedores.toList();
    var niveis = listItens.map((e) => e.nivel);
    var nivel = niveis.toSet().toList();
    print("LIST NIVEl $nivel");
    setState(() {
      _showProgress = true;
      step = lista.length;
    });

    print(lista);
    idNivel = listItens.first.nivel;

    for (var ni in nivel) {
      print("NIVel $ni");
      for (var forn in lista) {
        var tot = listItens
            .where((e) => e.fornecedor == forn)
            .where((w) => w.nivel == ni);
        var tot1 = tot.map((e) => e.total);
        var total = tot1.reduce((a, b) => a + b);
        var code = ('$codex$ni$forn');

        toast(context, 'Gerando Af ${code}...Aguarde!', duration: 5);

        var afp = afpedido ?? AfPedido();
        afp.af = int.parse(code);
        afp.pedido = widget.pedido.id;
        afp.total = total;
        afp.fornecedor = forn;
        afp.nivel = ni;
        afp.setor = widget.user.setor;
        AfPedidoApi.save(context, afp);

        var afs = af ?? AfAdd();
        afs.code = int.parse(code);
        afs.createdAt = DateTime.now().toIso8601String();
        afs.fornecedor = forn;
        afs.isenviado = false;
        afs.status = Status.ordemProcessada;
        afs.isativo = true;
        afs.nivel = ni;
        afs.setor = widget.user.setor;
        afs.isdespesa = false;

        ApiResponse<bool> response =  await AfAddApi.save(context, afs);
        if (response.ok) {
          afbloc.addItensNovos(1);
        }
        setState(() {
          currentStep++;
        });

        Compras itek;
        for (var ite in listItens) {
          itek = ite;
          if (ite.fornecedor == forn) {
            var itee = itek ?? Compras();
            itee.id = itek.id;
            itee.af = int.parse(code);
            print(itee);
            ComprasApi.save(context, itee);
          }
        }

        print('${codex}${forn} - ${total}');
      }
    }
    blocPedido.decQuant(1);

    print("KLKKLKLKLKL");
    var afs = pedidoAdd ?? PedidoAdd();
    afs.status = Status.pedidoProcessado;
    afs.isaf = true;
    afs.ischeck = true;
    await PedidoAddApi.save(context, afs);
    setState(() {
      _showProgress = false;
    });
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo("pedidos", PedidoPage()), replace: true);
  }
  showExcluir(
      BuildContext context,
      Compras dados,
      ) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          listItens.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.alias} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse registro?'),
            ),
          ],
        ),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _onClickExcuir(Compras dados) async {
    print('quantItens0 $_itens');

    var dado = dados ?? Compras();
    dado.id = dados.id;
    await ComprasApi.delete(context, dado).then((value) => _itens--);

    if (_itens > 0) {
      await iniciaBloc();
    }
    var ped = pedidoAdd ?? PedidoAdd();
    ped.id = pedidoAdd.id;
    ped.total = totalPedido;
    await PedidoAddApi.save(context, ped);

    print('quantitens2 $_itens');
    if (_itens == 0) {
      print("não tem mais");
      var ped = pedidoAdd ?? PedidoAdd();
      ped.id = pedidoAdd.id;
      await PedidoAddApi.delete(context, ped);
    }
  }

  _onClickPdf(List<Compras> itens) {
    PagesModel.get(context)
        .push(PageInfo("Imprimir", PedidosPdf(itens, mapFornecedores)));
  }

  recebeProduto(bool newValue, Compras dados) async {
    print("NOVALOR $newValue");
    if (newValue) {
      setState(() {
        itensRecebidos++;
      });
      print("ITENR $itensRecebidos");
      var dado = dados ?? Compras();
      dado.ischeck = newValue;
      ComprasApi.save(context, dado);
      print("CAT $categorias");

      if (categorias.contains(dados.categoria)) {
        AlmoxarifadoAd almo;
        var alm = almo ?? AlmoxarifadoAd();
        alm.escola = dados.escola;
        alm.produto = dados.produto;
        alm.alias = dados.alias;
        alm.categoria = dados.categoria;
        alm.unidade = dados.unidade;
        alm.created = DateTime.now().toIso8601String();
        alm.nomeescola = dados.nomeescola;
        alm.licitacao = dados.licitacao;
        alm.quantidade = dados.quantidade.toInt();
        alm.isativo = true;
        alm.istroca = false;
        alm.obs = "Adicionou ${dados.quantidade} na dispensa!";
        AlmoxarifadoAdApi.save(context, alm);
      }
      if (itensRecebidos == _itens) {
        var ped = pedidoAdd ?? PedidoAdd();
        ped.id = pedidoAdd.id;
        ped.status = Status.entregue;
        ped.ischeck = true;
        await PedidoAddApi.save(context, ped);
      }
    } else {
      print("aqui");
      setState(() {
        itensRecebidos--;
      });

      AlmoxarifadoAd almo;
      var alm = almo ?? AlmoxarifadoAd();
      alm.escola = dados.escola;
      alm.produto = dados.produto;
      alm.alias = dados.alias;
      alm.categoria = dados.categoria;
      alm.unidade = dados.unidade;
      alm.created = DateTime.now().toIso8601String();
      alm.nomeescola = dados.nomeescola;
      alm.licitacao = dados.licitacao;
      alm.quantidade = dados.quantidade.toInt() * -1;
      alm.isativo = true;
      alm.istroca = false;
      alm.obs = "Retirou ${dados.quantidade} na dispensa!";
      AlmoxarifadoAdApi.save(context, alm);
      print("ITENR $itensRecebidos");
      var dado = dados ?? Compras();
      dado.ischeck = newValue;
      ComprasApi.save(context, dado);
      if (categorias.contains(dados.categoria)) {
        /* AlmoxarifadoAd  almo;
      var alm = almo ?? AlmoxarifadoAd();
      AlmoxarifadoAdApi.delete(context, alm);
    }*/

      }
    }
  }
}
