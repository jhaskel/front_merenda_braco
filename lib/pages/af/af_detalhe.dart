import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/af_bloc.dart';
import 'package:merenda_escolar/core/bloc/contabilidade_bloc.dart';
import 'package:merenda_escolar/core/bloc/fornecedor_bloc.dart';
import 'package:merenda_escolar/core/bloc/itens_bloc.dart';
import 'package:merenda_escolar/core/bloc/nivel_bloc.dart';
import 'package:merenda_escolar/core/bloc/pedido_bloc.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/afAdd/Af.dart';
import 'package:merenda_escolar/pages/af/afAdd/af_api.dart';
import 'package:merenda_escolar/pages/af/af_api.dart';
import 'package:merenda_escolar/pages/af/orderm_fornecedor.dart';
import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pro.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/pdf/af_pdf.dart';
import 'package:merenda_escolar/utils/pdf/af_pdf_escola2.dart';
import 'package:merenda_escolar/utils/pdf/af_pdf_escola.dart';
import 'package:merenda_escolar/utils/pdf/oficio_pdf.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';

class AfDetalhe extends StatefulWidget {
  Af af;
  AfDetalhe(this.af);
  @override
  _AfDetalheState createState() => _AfDetalheState();
}

class _AfDetalheState extends State<AfDetalhe> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: "empreendimento_form");

  var _showProgress = false;
  Usuario get user => AppModel.get(context).user;
  bool _isAutorizado = false;
  bool _isEmpenhado;
  int codDespesa;
  int codeDespesa;
  int despesa;
  bool isdespesa = false;



  final numeroAf = TextEditingController();
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  TextEditingController dateCtl = TextEditingController();
  TextEditingController diaa = TextEditingController();
  var datax;
  bool loading = false;
  bool isFornecedor = false;

  Contabilidade conta;
  String numeroProcesso;
  List<PedidoItens> listItensx;
  List<Pedido> listPedido;
  List<Nivel> listNiveis;
  List<Fornecedor> listFornec;
  List<Contabilidade> contabilidade;
  List<Contabilidade> listConta;
  List<Af> listOrdem;
  List<Af> lista;
  Af ordem;

  final BlocAf blocx = BlocProvider.getBloc<BlocAf>();
  int totalAf = 0;
  double valorTotal;
  String nomeNivel;
  List<String> dias = [];
  Af get af => widget.af;
  Key key;
  bool _isLoading = true;
  bool _isLoadingNivel = true;
  bool _isLoadingPedidos = true;
  bool _isLoadingFornecedor = true;
  bool _isLoadingAf = true;


  AfAdd afAdd;
  Fornecedor forne;

  montaAfAdd(Af ordem){
     afAdd= AfAdd(
      id:ordem.id,
      nivel:ordem.nivel,
      setor:ordem.setor,
      code:ordem.code,
      fornecedor:ordem.fornecedor,
      isenviado:ordem.isenviado,
      status:ordem.status,
      isativo:ordem.isativo,
      createdAt:ordem.createdAt,
      processo:ordem.processo,
      despesa: ordem.despesa,
      coddespesa: ordem.coddespesa,
      codedespesa: ordem.codedespesa,
      isdespesa:ordem.isdespesa,
    );


  }

  getContabilidadeById(int despesa){
    Provider.of<ContabilidadeBloc>(context, listen: false)
        .findById(context,despesa)
        .then((value) {
      setState(() {

       contabilidade = value;
       conta = contabilidade.first;
       print("CONTA ${conta}");
      });
    });
  }

  init(){
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code).then((value) {
      listOrdem = value;
      bool ise = false;
      ordem=listOrdem.first;
      despesa=ordem.despesa;
      if(ordem.status ==Status.ordemEmpenhada){
        ise = true;
      }

      if(ordem.status ==Status.ordemAutorizada || ordem.status ==Status.ordemEmpenhada || ordem.status == Status.ordemFornecedor){
        print("AKIAUTORIZADA");
        setState(() {
          isdespesa = true;
          getContabilidadeById(despesa);
        });
      }

      print("ise $ise");
      setState(() {
        _isEmpenhado = ise;
        montaAfAdd(ordem);
        print("ise2 $_isEmpenhado");
      });
    });
  }

  iniciaBloc(){
    Provider.of<ItensBloc>(context, listen: false)
        .fetchAf(context,widget.af.code)
        .then((value) {
      setState(() {
        var xy = value.map((e) => e.total);
        valorTotal = xy.reduce((a, b) => a + b);
        print('vt$valorTotal');
        _isLoading = false;
      });
    });

    Provider.of<ItensBloc>(context, listen: false)
        .fetchAf(context,widget.af.code)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    Provider.of<ContabilidadeBloc>(context, listen: false)
        .fetchNivel(context,widget.af.code)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    var blocNivel =  Provider.of<NivelBloc>(context, listen: false);
    listNiveis = blocNivel.lista;
    setState(() {
      _isLoadingNivel = false;
      for (var gh in listNiveis) {
        if (gh.id == widget.af.nivel) {
          nomeNivel = gh.nome;
        }
      }
    });

    Provider.of<PedidoBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        _isLoadingPedidos = false;
      });
    });

    Provider.of<FornecedorBloc>(context, listen: false)
        .fetchId(context, widget.af.fornecedor)
        .then((value) {
      setState(() {
        _isLoadingFornecedor = false;
        nomeFor = value.first.alias;
      });
    });

    Provider.of<ContabilidadeBloc>(context, listen: false)
        .fetchNivel(context, widget.af.nivel)
        .then((value) {
      setState(() {
        listConta = value;
      });
    });

    //  _pegaTotal();

  }

  @override
  void initState() {
    init();
    iniciaBloc();
    super.initState();
  }


  bool excluir = false;
  String nomeFor = '';
  String cnpj = '';
  String email = '';

  @override
  Widget build(BuildContext context) {


    if(user.isEmpenho()){
      if(!_isLoading &&  !_isLoadingNivel && !_isLoadingPedidos &&  !_isLoadingFornecedor ) {

        return Scaffold(
          body: body(),
          bottomNavigationBar: user.isEmpenho()?buttonEmpenhar():Container(),
        );
      }else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Center(child: Text("Buscando produtos....",style: TextStyle(fontSize: 30,color: Colors.green),)),),
            CircularProgressIndicator()
          ],

        );
      }
    }else

    if(!_isLoading &&  !_isLoadingNivel && !_isLoadingPedidos &&  !_isLoadingFornecedor ) {
      return Scaffold(
        body: body(),
        bottomNavigationBar: user.isAdmin() && widget.af.status== Status.ordemProcessada || widget.af.status== Status.ordemAutorizada
            ?buttonAutorizar()
            :buttonFornecedor(),
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Center(child: Text("Buscando produtos....",style: TextStyle(fontSize: 30,color: Colors.green),)),),
          CircularProgressIndicator()
        ],

      );
    }


  }

  body() {
    var blocaf = Provider.of<AfBloc>(context);
    listOrdem = blocaf.af;
    if(ordem!=null){
      ordem=listOrdem.first;
    }
    montaAfAdd(ordem);


    final blocForn = Provider.of<FornecedorBloc>(context);

    if(listFornec !=null){
      listFornec = blocForn.lista1;
      forne = listFornec.first;
      nomeFor = listFornec.first.alias;
      cnpj = listFornec.first.cnpj;
      email = listFornec.first.email;
    }

    final blocPedido = Provider.of<PedidoBloc>(context);
    if(listPedido !=null){
      listPedido = blocPedido.lista;
    }

    final bloc = Provider.of<ItensBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else

      listItensx = bloc.lista;

    var xy = listItensx.map((e) => e.total);
    valorTotal = xy.reduce((a, b) => a + b);


    var listItens = listItensx
        .sortedByNum((p) => p.escola); // list sorted by age


    numeroProcesso = listItensx.first.processo;

    List<Pro> lista = [];
    var pro5;
    var pro =
    listItens.map((e) => e.produto).toSet().toList();
    for (var p in pro) {
      var pro1 =
      listItens.where((e) => e.produto == p).toList();
      var pro2 = pro1.map((e) => e.quantidade);
      var pro3 = pro2.reduce((a, b) => a + b);

      var pro4 = pro1.map((e) => e.total);
      pro5 = pro4.reduce((a, b) => a + b);

      lista.add(Pro(
          pro1.first.alias,
          pro1.first.unidade,
          pro3,
          pro5,
          pro1.first.valor,
          pro1.first.created,
          pro1.first.cod,
          pro1.first.nomenivel));
    }
    //separa os numeros dos pedidos


    var itensPedido = listItens.map((e) => e.id).toList();

print('_isAutorizado ${_isAutorizado}');
print('widget.af.status ${widget.af.status}');
print('isdespesa ${isdespesa}');
    return widget.af.status ==Status.ordemProcessada || widget.af.status ==Status.ordemAutorizada || widget.af.status ==Status.ordemEmpenhada ||  widget.af.status ==Status.ordemFornecedor
        ? BreadCrumb(

      actions: [
        _isAutorizado || widget.af.status != Status.ordemProcessada || isdespesa
            ?Container(
            child: Row(
              children: [
                user.isAdmin() || user.isGerente() || user.isMaster()
                    ?Tooltip( message: "Oficio",
                       child: PrintButton(
                      color: Colors.amber,
                      // onPressed: (){showBottomSheet(context,listItens,nomeFor);}
                      onPressed: (){
                        showOficio(
                          listItens,
                          numeroProcesso,
                          conta
                          );}
                  ))
                    :Container(),

                Tooltip(message: "lista para Compras",
                    child: PrintButton(
                      onPressed: () => _onClickAdd(
                        lista,
                        widget.af.code.toString(),
                        nomeFor,
                        cnpj),
                  ),
                ),
                user.isAdmin() || user.isGerente() || user.isMaster()
                    ?Tooltip(message: "lista para fornecedores",
                    child: PrintButton(color: Colors.blue,
                        onPressed: (){_onClickPdfFornecedor(listItens, nomeFor);}))
                    :Container(),
              ],))
            :Container(),

      ],
      child: _itens(listItens, lista),
    )
        :BreadCrumb(
      child: _itens(listItens, lista),
    );
  }

  MaterialButton buttonAutorizar() {
    return MaterialButton(

      onPressed: (){
        showBottomDespesa();
     /*   if(!af.isdespesa && !_isAutorizado){
          _alteraStatus() ;
        }else{
          _alteraStatusRevogado() ;
        }*/
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !af.isdespesa && !_isAutorizado
            ?Text('Autorizar',style: AppTextStyles.titleBold,)
            :Text('Alterar Despesa',style: AppTextStyles.titleBold,),
      ),
      color: Colors.blue,
    );
  }

  MaterialButton buttonEmpenhar() {
    return MaterialButton(
      onPressed: (){
        if(!_isEmpenhado){
          _alteraStatusEmpenho() ;
        }else{
          _alteraStatusEmpenhoRevogado() ;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !_isEmpenhado
            ?Text('Definir como Empenhado',style: AppTextStyles.titleBold,)
            :Text('Remover Empenho',style: AppTextStyles.titleBold,),
      ),
      color: !_isEmpenhado ?Colors.blue:Colors.grey,
    );
  }
  MaterialButton buttonFornecedor() {
    return !isFornecedor && widget.af.status!=Status.ordemFornecedor
        ? MaterialButton(
      onPressed: (){
        _alteraStatusFornecedor() ;
      }
      ,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Text('Definir como Enviada para Fornecedor',style: AppTextStyles.titleBold,)

      ),
      color: Colors.blue,
    )
        :MaterialButton(

      onPressed: null
      ,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Text('Ordem Enviada para Fornecedor',style: AppTextStyles.titleBold,)

      ),
      color: Colors.grey,
    );
  }

  _itens(List<PedidoItens> listItens, List<Pro> lista) {
    return _cardProduto(lista);
  }

  _cardProduto(List<Pro> lista) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text("cod",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Text("Nome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text("Unidade",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text("Quant",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),

              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text("Valor",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),


            ],
          ),
        ),
        Divider(height: 2,thickness: 2,),
        Expanded(
          child: RawScrollbar(
            controller: ScrollController(),
            isAlwaysShown: true,
            thickness: 10,
            radius: Radius.circular(15),
            thumbColor: Colors.greenAccent,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    Pro i = lista[index];
                    return Column(
                      children: [
                        Container(
                          height: 30,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(i.cod.toString(),style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),
                              Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Text(i.nome,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(i.unidade,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(i.quantidade.toString(),style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),

                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text("R\$ ${formatador.format(i.valor)}",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text("R\$ ${formatador.format(i.total)}",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 16),),
                              ),


                            ],
                          ),
                        ),
                        Divider(thickness: 2,)
                      ],
                    );

                    return Text('');
                  }),
            ),
          ),
        ),
      ],
    );
  }

  _alteraStatus() async {
    setState(() {
      loading = true;
      _isAutorizado = true;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);

    var cate = afAdd ?? AfAdd();
    cate.status = Status.ordemAutorizada;
    await AfAddApi.save(context, cate);
    afbloc.decItensNovos(1);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);

    setState(() {
      loading = false;
    });
  }

  _alteraStatusRevogado() async {
    setState(() {
      loading = true;
      _isAutorizado = false;
      af.isdespesa = false;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);

    var cate = afAdd ?? AfAdd();
    cate.isdespesa = false;
    cate.status = Status.ordemProcessada;
    await AfAddApi.save(context, cate);
    afbloc.decItensNovos(1);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);

    setState(() {
      loading = false;
    });

  }

  _alteraStatusEmpenho() async {
    setState(() {
      loading = true;
      _isEmpenhado = true;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);

    var cate = afAdd ?? AfAdd();
    cate.status = Status.ordemEmpenhada;
    await AfAddApi.save(context, cate);
    afbloc.decItensAutorizados(1);
    afbloc.addItensEmpenhados(1);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);

    setState(() {
      loading = false;
    });
  }

  _alteraStatusEmpenhoRevogado() async {
    setState(() {
      loading = true;
      _isEmpenhado = false;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);
    var cate = afAdd ?? AfAdd();
    cate.status = Status.ordemAutorizada;
    await AfAddApi.save(context, cate);
    afbloc.decItensEmpenhados(1);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);

    setState(() {
      loading = false;
    });

  }

  _alteraStatusFornecedor() async {
    setState(() {
      loading = true;
      isFornecedor = true;
    });

    var cate = afAdd ?? AfAdd();
    cate.status = Status.ordemFornecedor;
    await AfAddApi.save(context, cate);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);
    setState(() {
      loading = false;
    });

  }



  _onClickAdd(List<Pro> itens, String af, String nomeFor, String cnpj) {
    PagesModel.get(context).push(
        PageInfo("Imprimir", AfPdf(key, itens, widget.af, nomeFor, nomeNivel)));

   if(widget.af.status==Status.ordemAutorizada){
     _alteraStatusEmpenho();
   }

  }

  _onClickPdfFornecedor(List<PedidoItens> itens, String nomeFor) async {

    await PagesModel.get(context)
        .push(PageInfo("Imprimir", AfPdfEscola(itens, nomeFor)));

  }

  _onClickOrdemFornecedor(List<PedidoItens> itens, String nomeFor, List<String> dias) async {

    await PagesModel.get(context)
        .push(PageInfo("$nomeFor", OrdemFornecedor(itens, nomeFor,widget.af)));


  }

  _onClickAdd3(String processo, String datax ) {
    print('processo ${processo}');
    print('af ${widget.af}');
    print('conta ${conta}');
    print('valortotal ${valorTotal}');
    print('despesa ${despesa}');

    PagesModel.get(context).push(PageInfo("Imprimir",
        OficioPdf(processo, widget.af,conta,datax, valorTotal, despesa,)));

  }


  showBottomDespesa(){
    int i =0;
    bool clicou = false;
    if (widget.af.despesa != null) {
      i = widget.af.despesa;
    }

    if (ordem.despesa != null && ordem.despesa >0 ) {
      i = ordem.despesa;
    }

    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 200,
                        child: ListView.builder(
                            itemCount: listConta.length,
                            itemBuilder: (context, index) {
                              Contabilidade con = listConta[index];
                              if (i > 0) {
                                print("GG1");
                                if (con.cod == i) {
                                  print("GG2");
                                  return ListTile(
                                    onTap: (){
                                      setState(() {
                                        despesa = con.id;
                                        codDespesa = con.code;
                                        codeDespesa = con.code;
                                        i = con.cod;

                                      });
                                    },
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(con.nomeProjeto),

                                      ],

                                    ),
                                    subtitle: Text(con.cod.toString()),

                                    trailing: Icon(Icons.check,
                                        color: i == con.id
                                            ? Colors.green : Colors.black),
                                  );
                                }
                              }
                              print("GG5 ${con.code}");
                              return ListTile(
                                onTap: (){
                                  setState(() {
                                    despesa = con.id;
                                    codDespesa = con.cod;
                                    codeDespesa = con.code;
                                    print("despesa $despesa");
                                    print("cod $codDespesa");
                                    print("code $codeDespesa");
                                    clicou=true;
                                  });
                                },
                                subtitle: Text(con.cod.toString()),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(con.nomeProjeto),
                                  ],

                                ),
                                trailing: Icon(Icons.check,
                                    color: despesa == con.id
                                        ? Colors.green : Colors.black)
                              );
                            }
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: (){
                                pop(context);

                              },
                              child: Text("Cancelar"),
                              color: Colors.black54,
                            ),
                            SizedBox(width: 20,),
                            clicou ?MaterialButton(
                              onPressed: () async{
                                setState((){
                                  clicou = true;
                                });
                                 await _defineDespesa();
                                setState((){
                                  clicou = false;
                                  isdespesa = true;
                                });
                                pop(context);
                              },
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Finalizar"),
                              ),
                              color: Colors.blue,

                            ):Container(),
                          ],

                        ),
                      )
                    ],

                  );
                }),
          );
        });
  }




  _defineDespesa() async {
    setState(() {
      loading = true;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);
    var afConta = Provider.of<ContabilidadeBloc>(context, listen: false);
    await afbloc.ativaDespesa();

    // if (despesa > 0) {
    var cate = afAdd ?? AfAdd();
    cate.despesa = despesa;
    cate.codedespesa = codeDespesa;
    cate.coddespesa = codDespesa;
    cate.isdespesa = true;
    cate.status = Status.ordemAutorizada;

    await AfAddApi.save(context, cate);
    afbloc.decItensNovos(1);
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code);

       await getContabilidadeById(despesa);

    //   }
    setState(() {
      loading = false;
    });
  }

  showOficio( List<PedidoItens> listItens,
      String numeroProcesso, Contabilidade conta) {
    bool progress = false;
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        _onClickAdd3( numeroProcesso, datax);
      },
    );

    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    // configura o  AlertDialog

    AlertDialog alerta = AlertDialog(
      title: Text("Selecione uma data"),
      content: Container(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: dateCtl,
            decoration: InputDecoration(
              labelText: "Data do Oficio",
            ),
            onTap: () async {
              DateTime date = DateTime(1900);
              FocusScope.of(context).requestFocus(new FocusNode());

              date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030));
              datax = date.toIso8601String();
              dateCtl.text =
              ('${date.day.toString()}/${date.month.toString()}');
            },
          ),
        ),
      ),
      actions: [
        cancelaButton,
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }



}
