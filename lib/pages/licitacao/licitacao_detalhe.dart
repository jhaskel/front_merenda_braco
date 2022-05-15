import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/almoxarifado_bloc.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd_api.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_add.dart';
import 'package:merenda_escolar/pages/estoque/estoques_detalhe.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/pdf/licitacao_pdf_estoque.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';

class LicitacaoDetalhe extends StatefulWidget {
  final Licitacao licitacao;
  LicitacaoDetalhe({this.licitacao});

  @override
  _LicitacaoDetalheState createState() => _LicitacaoDetalheState();
}

class _LicitacaoDetalheState extends State<LicitacaoDetalhe> {
  Licitacao get dados => widget.licitacao;
  bool _showProgress = false;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  int selectedValue = 0;
  bool _isLoading = true;
  bool _isLoading2 = true;
  bool _isLoadingTroca = true;
  String nomeEscola;
  List<Estoque> lista = [];
  List<Almoxarifado> listaAlmoxarifado = [];

  //para transferir produtos
  Map<String, int> mapEscola = new Map();
  Map<int, String> mapEscola2 = new Map();
  List<UnidadeEscolar> escolas;
  List<Almoxarifado> listTrocas;
  int idEscola;
  String nomeDaEscola;
  var hoje = DateTime.now();
  DateTime validade;
  int prazo;
  int falta;
  int aba = 0;

  final tQuantidade = TextEditingController();

 iniciaTroca(){
   Provider.of<AlmoxarifadoBloc>(context, listen: false)
       .fetchTroca(context, widget.licitacao.id)
       .then((value) {
     setState(() {
       _isLoadingTroca = false;
       listTrocas = value;
     });
   });
 }

  iniciaBloc() {

    Provider.of<AlmoxarifadoBloc>(context, listen: false)
        .fetch(context, widget.licitacao.id)
        .then((_) {
      setState(() {
        _isLoadingTroca = false;
      });
    });
    Provider.of<EstoqueBloc>(context, listen: false)
        .fetchLicitacao(context, widget.licitacao.id)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });




    Provider.of<EscolaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        for (var gh in value) {
          mapEscola.putIfAbsent(gh.alias, () => gh.id);
        }
        print("mapnivel${mapEscola}");

        for (var gh in value) {
          mapEscola2.putIfAbsent(gh.id, () => gh.nome);
        }
        print("mapnivel2${mapEscola2}");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime homologado = DateTime.parse(widget.licitacao.homologadoAt);
    prazo = int.parse(widget.licitacao.prazo);
    validade =  homologado.add(Duration(days: prazo));
    print("VAL $homologado");
    print("VAL $validade");
    falta = validade.difference(hoje).inDays;

    print("VAL2 $falta");

    iniciaBloc();
  }

  static Widget giveCenter(String yourText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("$yourText"),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Text(
            "Novo",
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  List<String> names = ['Itens', 'Dispensa'];

  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      actions: [
        PrintButton(onPressed: () {
          _onClickEstoquePdf(lista);
        })
      ],
      child: _body(),
    );
  }

  _body() {

    final Map<int, Widget> sWidget = <int, Widget>{
      0: Text(names[0]),
      1: Text(names[1]),
    };

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Processo Licitatório: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    dados.processo,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Edital: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(dados.edital),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Objeto: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 500,
                  child: Text(
                    dados.objeto,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Resumo: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    dados.alias,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Valor Final: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text('R\$  ${formatador.format(dados.valorfinal)}'),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Validade: ",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text("Restam $falta dias"),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: CupertinoSegmentedControl(
                  padding: EdgeInsets.all(12),
                  borderColor: Colors.blue,
                  selectedColor: Colors.blue,
                  groupValue: selectedValue,
                  onValueChanged: (dynamic val) {
                    setState(() {
                      selectedValue = val;
                    });
                  },
                  children: sWidget,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              LayoutBuilder(builder: (context, constraints) {
                return janela();
              })
            ],
          ),
        ],
      ),
    );
  }

  janela() {
    if (selectedValue == 0) {
      return itens();
    }
    if (selectedValue == 1) {
      return dispensa();
    }
  }

  itens() {
    if (selectedValue == 0) {
      final bloc = Provider.of<EstoqueBloc>(context);
      if (bloc.lista.length == 0 && _isLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (bloc.lista.length == 0 && !_isLoading) {
        return Column(
          children: [
            Container(
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  _onClickProdutoAdd();
                },
                child: Icon(Icons.add),
              ),

            ),
            Center(
              child: Text('Sem registros!'),
            ),
          ],

        );
      } else
        lista = bloc.lista;
      return Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  _onClickProdutoAdd();
                },
                child: Icon(Icons.add),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  Estoque c = lista[index];

                  return _cardProduto(c);
                },
              ),
            )
          ],
        ),
      );
    }
  }
  dispensa() {
    final bloc = Provider.of<AlmoxarifadoBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      listaAlmoxarifado = bloc.lista;
      listTrocas = bloc.listaTroca;
    var escolas = listaAlmoxarifado.map((e) => e.nomeescola).toSet().toList();
    if (nomeEscola != null) {
      listaAlmoxarifado =
          listaAlmoxarifado.where((e) => e.nomeescola == nomeEscola).toList();

      listTrocas =
          listTrocas.where((e) => e.nomeescola == nomeEscola).toList();

    }

    print(listaAlmoxarifado.length);
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: escolas.length,
                  itemBuilder: (context, index) {


                 /*   var a = listaAlmoxarifado.where((e) => e.nomeescola==escolas[index]);
                    var b = a.map((e) => e.quant);
                    var c = b.reduce((a, b) => a+b);

                     print("qd itens = $c");*/


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            nomeEscola = escolas[index];
                            iniciaTroca();
                          });
                        },
                        color: nomeEscola==escolas[index]?Colors.green:Colors.black26,
                        child: Text(
                          escolas[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );

                    return Text(escolas[index]);
                  })),
          nomeEscola != null
              ? Container(
                  height: 50,
                  child: Text(
                    nomeEscola,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )
              : Container(),
          nomeEscola != null
              ?
          Container(
            height: 50,
            child: Row(
              children: [
                InkWell(
                    child: Text("Na Dispensa",style: TextStyle(fontWeight: aba==0?FontWeight.bold:FontWeight.normal),),
                  onTap: (){
                      setState(() {
                        aba = 0;
                      });
                  },

                ),
                SizedBox(width: 20,),
                InkWell(

                    child: Text('Transações Realizadas',style: TextStyle(fontWeight: aba==1?FontWeight.bold:FontWeight.normal),),
                  onTap: (){
                    setState(() {
                      aba = 1;
                    });
                  },
                )
              ],
            ),
          )
              : Container(),
          nomeEscola!=null
              ? Expanded(
            child: aba ==0? ListView.builder(
                itemCount: listaAlmoxarifado.length,
                itemBuilder: (context, index) {
                  Almoxarifado c = listaAlmoxarifado[index];
                  return _cardAlmoxarifado(c);

                },
              ):ListView.builder(
              itemCount: listTrocas.length,
              itemBuilder: (context, index) {
                Almoxarifado c = listTrocas[index];

                  return _cardTransacao(c);



              },
            ),
          ):Container()
        ],
      ),
    );
  }

  _cardProduto(Estoque c) {
    double estoque;
    if(c.comprado !=null && c.licitacao == widget.licitacao.id){
      estoque  = ( c.quantidade - c.comprado);
    }else{
      estoque  = ( c.quantidade - 0);
    }
    return ListTile(
      onTap: () {
        _onClickProduto(c);
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(c.alias),
          Text(c.nomelicitacao)

        ],

      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text( 'R\$ ${formatador.format(c.valor)}' ?? "",),
              SizedBox( width: 10,),
              Text(c.unidade),
              SizedBox(width: 10,),
              c.agrofamiliar
                  ? Text('Agric. Familiar', style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                  : Container()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              Text("Em Estoque"),
              SizedBox(width: 10,),
              Text(estoque.toString(),style: TextStyle(fontSize: 20,color: estoque >0?Colors.green:Colors.red),)
            ],
          )


        ],
      ),
      trailing: IconButton(
        onPressed: () {
          _onClickProdutoEdit(c);
        },
        icon: Icon(Icons.edit),
      ),
    );
  }
  _cardAlmoxarifado(Almoxarifado c) {
   return c.quant==0?Container():ListTile(
     title: text(c.alias ?? "",),
     subtitle: Row(
       children: [
         Text("Em Estoque: "),
         SizedBox(width: 5,),
         Text(
           c.quant.toString() ?? "",
           style: TextStyle(
               fontSize: 22,
               color: Colors.blue,
               fontWeight: FontWeight.bold),
         ),
         SizedBox(width: 5,),
         Text(c.unidade),


       ],
     ),
     trailing: IconButton(
         icon: Icon(
           Icons.compare_arrows,
           size:
           30,
           color: Colors.green,
         ),
         onPressed: () {
           showTransferir(context, c);
         }),
   );


  }
  _cardTransacao(Almoxarifado c) {


    return  ListTile(
      title: text(c.alias ?? "",),
      subtitle: Text(c.obs?? ""),

    );

  }

  _onClickProduto(Estoque c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(c.alias, EstoquesPage(c, widget.licitacao)));
  }

  _onClickProdutoEdit(Estoque c) {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(
        c.alias,
        EstoqueAdd(
          licitacao: widget.licitacao,
          estoque: c,
        )));
  }

  _onClickProdutoAdd() {
    PagesModel nav = PagesModel.get(context);
    nav.push(PageInfo(
        "Novo produto",
        EstoqueAdd(
          licitacao: widget.licitacao,
        )));
  }

  showTransferir(BuildContext context, Almoxarifado c) async {
    print("idEscola $idEscola");
    Widget comprarButton = MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Transferir Produto",
          style: AppTextStyles.heading15White,
        ),
      ),
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      onPressed: () async {
        String quant = tQuantidade.text;
        int quantidade;
        if (quant != "" && idEscola !=null) {
          quantidade = int.parse(quant);
          if (quantidade > c.quant) {
            toast(context, "Quantidade máx ${c.quantidade}");
          } else {
            _onClickSalvar(c, quant);
            pop(context);
          }
        }
      },
    );

    //configura o AlertDialog

    AlertDialog alert = AlertDialog(
      title: Container(
        width: 200,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  tQuantidade.clear();
                  pop(context);
                })
          ],
        ),
      ),
      content: Container(
        width: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text(
                  c.alias,
                  style: AppTextStyles.heading15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: AppColors.primaria,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    c.unidade,
                    style: AppTextStyles.body11White,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Estoque: ',
                      style: AppTextStyles.body11,
                    ),
                  ),
                  Container(
                    child: Text(
                      c.quant.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  autofocus: true,
                  controller: tQuantidade,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantidade'),
                  validator: (value) =>
                      value.isEmpty ? 'Campo precisa ser preenchido' : null,
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: mapEscola.keys.toList(),
                  label: "Escola",
                  onChanged: (String data) {
                    setState(() {
                      idEscola = mapEscola[data];
                      nomeDaEscola = data;
                      print("iddddd $idEscola");
                    });
                  },
                  selectedItem: 'Selecione uma Escola'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: comprarButton,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Descrição', style: AppTextStyles.bodyTitleBold)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 300,
                  child: Text(
                    c.alias,
                    style: AppTextStyles.body11,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  )),
            ),
          ],
        ),
      ),
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
            return
            Container(
              width: 300,
              height: 600,
              child: alert,
            );

          }
        );
      },
    );
  }



  Future<void> _onClickSalvar(Almoxarifado c, String quant) async {

    AlmoxarifadoAd almoxarifadoAd;

    var bloc = Provider.of<AlmoxarifadoBloc>(context,listen: false);
    var produ = almoxarifadoAd ?? AlmoxarifadoAd();
    produ.produto= c.produto;
    produ.licitacao = c.licitacao;
    produ.escola = c.escola;
    produ.alias = c.alias;
    produ.quantidade = int.parse(quant)*-1;
    produ.unidade = c.unidade;
    produ.categoria = c.categoria;
    produ.nomeescola = c.nomeescola;
    produ.created = DateTime.now().toIso8601String();
    produ.isativo = true;
    produ.istroca = true;
    produ.obs = "Cedeu para $nomeDaEscola, ${quant} ${c.unidade} da dispensa!";

    ApiResponse<bool> response = await AlmoxarifadoAdApi.save(context, produ);

    if (response.ok) {
      var produ = almoxarifadoAd ?? AlmoxarifadoAd();
      produ.produto= c.produto;
      produ.licitacao = c.licitacao;
      produ.escola = idEscola;
      produ.alias = c.alias;
      produ.quantidade = int.parse(quant);
      produ.unidade = c.unidade;
      produ.categoria = c.categoria;
      produ.nomeescola = nomeDaEscola;
      produ.created = DateTime.now().toIso8601String();
      produ.isativo = true;
      produ.istroca = true;
      produ.obs = "Recebeu da ${c.nomeescola}, ${quant} ${c.unidade}";
      ApiResponse<bool> response = await AlmoxarifadoAdApi.save(context, produ);

     iniciaBloc();

      alert(context, "Almoxarifado atualizado com sucesso", callback: () {


      });
    } else {
      alert(context, response.msg);
    }

  }

  _onClickEstoquePdf(List<Estoque> lista) {
    PagesModel.get(context)
        .push(PageInfo("Imprimir", LicitacaoPdfEstoque(lista,widget.licitacao)));
  }
}
