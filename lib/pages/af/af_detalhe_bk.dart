
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
import 'package:merenda_escolar/pages/af/orderm_fornecedor1.dart';
import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pro.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
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

import 'package:validadores/Validador.dart';

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
  List<Contabilidade> contabilidades;
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
      codedespesa: ordem.codedespesa,
      isdespesa:ordem.isdespesa,


    );
  }

  init(){
    Provider.of<AfBloc>(context, listen: false)
        .fetchCode(context,widget.af.code).then((value) {
      listOrdem = value;
      bool ise = false;
      ordem=listOrdem.first;

      if(ordem.status ==Status.ordemEmpenhada){
        ise = true;
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
        contabilidades = value;

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


    return widget.af.status ==Status.ordemProcessada || widget.af.status ==Status.ordemAutorizada || widget.af.status ==Status.ordemEmpenhada ||  widget.af.status ==Status.ordemFornecedor
        ? BreadCrumb(

      actions: [
        _isAutorizado || widget.af.status != Status.ordemProcessada ?Container(
            child: Row(
              children: [

                user.isAdmin() || user.isGerente() || user.isMaster() ?Tooltip(
                  message: "lista para fornecedores",
                  child: PrintButton(
                      color: Colors.blue,
                      

                     // onPressed: (){showBottomSheet(context,listItens,nomeFor);}
                      onPressed: (){_onClickOrdemFornecedor(listItens, nomeFor, dias);}
                  ),
                ):Container(),
                Tooltip(
                  message: "lista para Compras",
                  child: PrintButton(
                    onPressed: () => _onClickAdd(
                        lista,
                        widget.af.code.toString(),
                        nomeFor,
                        cnpj),
                  ),
                ),
              ],
            )):Container(),

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
        if(!af.isdespesa && !_isAutorizado){
          _alteraStatus() ;
        }else{
          _alteraStatusRevogado() ;
        }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: !af.isdespesa && !_isAutorizado
                      ?Text('Autorizar',style: AppTextStyles.titleBold,)
                      :Text('Remover Autorização',style: AppTextStyles.titleBold,),
                ),
      color: !af.isdespesa && !_isAutorizado ?Colors.blue:Colors.grey,
              );
  }

  MaterialButton buttonEmpenhar() {
    print("STATUS ${ordem.status}");
    print("STATUS2 ${_isEmpenhado}");
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
      cate.isdespesa = true;
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

  Future<void> _alteraStatus2(
      BuildContext context, bool res, Fornecedor forne, [String numeroAf]) async {
    setState(() {
      _showProgress = true;
    });

    var ite = af ?? Af();
    var status = Status.pedidoAutorizado;
    var titulo = 'Af Autorizada';
    var content =
        'A Af de nº ${af.code} foi autorizada com Sucesso.Você já pode providenciar as mercadorias para entrega.'
        '\nEntre no endereço ${DESTINO_URL} para acompanhar os detalhes da Af';
    if (!res) {
      status = Status.pedidoProcessado;
      titulo = 'Af Revogada';
      content =
      'A Af de nº ${af.code} foi revogada! Desculpe os transtornos, mais informações na Secretaria da Educação!';
    }
    ite.status = status;
    ite.isenviado = res;

    ApiResponse<bool> response = await AfApi.save(context, ite);

    blocx.inAf.add(totalAf - 1);

    if (response.ok) {
      Email emailx;

      var emaail = emailx ?? Email();

      emaail.nome = forne.nome;
      emaail.assunto = titulo;
      emaail.email = forne.email;
      emaail.content = content;
      emaail.created = DateTime.now().toString();
      await EmailApi.save(emaail);

      res
          ? toast(context, 'Af Autorizada com Sucesso')
          : toast(context, 'Af foi  Revogada');
      setState(() {
        _showProgress = false;
        PagesModel.get(context).pop();
      });
    } else {
      alert(context, response.msg);
    }
  }


  _onClickAdd(List<Pro> itens, String af, String nomeFor, String cnpj) {
    PagesModel.get(context).push(
        PageInfo("Imprimir", AfPdf(key, itens, widget.af, nomeFor, nomeNivel)));
  }

  _onClickAdd2(List<PedidoItens> itens, String nomeFor, List<String> dias) async {

    await PagesModel.get(context)
        .push(PageInfo("Imprimir", AfPdfEscola(itens, nomeFor)));


  }

  _onClickOrdemFornecedor(List<PedidoItens> itens, String nomeFor, List<String> dias) async {

    await PagesModel.get(context)
        .push(PageInfo("$nomeFor", OrdemFornecedor(itens, nomeFor,widget.af)));


  }

  _onClickAdd3(List<PedidoItens> itens, String processo, Contabilidade conta,
      double valorTotal) {
/*
    PagesModel.get(context).push(PageInfo("Imprimir",
        OficioPdf(processo, widget.af, conta,  valorTotal, despesa)));*/

  }



  showBottomSheet(BuildContext context,List<PedidoItens> itens, String nomeFor){

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 500,
                        child: Row(
                          children: [
                            Container(
                                width: 300,
                                child: TextField(
                                  controller: diaa,
                                )
                            ),
                            Container(
                              width: 50,
                              child: MaterialButton(
                                  color: Colors.blue,
                                  child: Text('Adicionar',style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    setState(() {
                                      dias.add(diaa.text);
                                      diaa.clear();
                                      print(dias);
                                    });
                                  }),
                            ),
                          ],

                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dias.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  setState(() {
                                    dias.remove(dias[index]);
                                  });

                                },
                                child: Chip(
                                  label: Text(dias[index],style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
                              );
                            }
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: dias.length>0?MaterialButton(
                          onPressed: (){
                          //  _onClickAdd2(itens, nomeFor,dias);
                            _onClickOrdemFornecedor(itens, nomeFor,dias);

                            pop(context);
                          },
                          color: Colors.blue,
                          child: Text('Finalizar',style: TextStyle(color: Colors.white)),
                        ):MaterialButton(
                          onPressed: (){
                            alert(context,'Digite uma data');
                          },
                          color: Colors.black26,
                          child: Text('Finalizar',style: TextStyle(color: Colors.white)),
                        ),
                      )

                    ],

                  );
                }),
          );
        });
  }
  showBottomDespesa(BuildContext context){
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
                    children: [
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: contabilidades.length,
                            itemBuilder: (context, index) {
                              Contabilidade con = contabilidades[index];
                              if (i > 0) {
                                print("GG1");
                                if (con.cod == i) {
                                  print("GG2");
                                  return ListTile(
                                    title: Text(con.cod.toString()),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(con.nomeProjeto),
                                        Text(con.nomeReceita)
                                      ],

                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                   //       despesaReal = con.id;
                                       //   despesa = con.code;
                                          i = con.cod;

                                        });

                                      },
                                      icon: Icon(Icons.check,
                                          color: i == con.id
                                              ? Colors.green : Colors.black),
                                    ),
                                  );
                                }
                              }

                              print("GG5 ${con.code}");
                              return ListTile(
                                title: Text(con.cod.toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(con.nomeProjeto),
                                    Text(con.nomeReceita)
                                  ],

                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      i = con.id;
                                    //  despesaReal = con.id;
                                  //    despesa = con.code;

                                    });
                                    print("i $i");
                                    print("index $index");


                                  },
                                  icon: Icon(Icons.check,
                                      color: i == con.id
                                          ? Colors.green : Colors.black),
                                ),
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
                            i>0 ?MaterialButton(
                              onPressed: () async{
                                setState((){
                                  clicou = true;
                                });
                              //  await _defineDespesa(despesaReal,despesa);
                                setState((){
                                  clicou = false;
                                });
                                pop(context);
                              },
                              child: !clicou ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Finalizar"),
                              ):Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.white,),
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

  showAutorizar(BuildContext context, Fornecedor forne) {
    int despe = 0;
    if (widget.af.despesa != null) {
      despe = widget.af.despesa;
    }
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {

        pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
    //    _alteraStatus(context, true, forne,numeroAf.text);

      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Numero da AF'),
      content: Container(
        width: 380,
        height: 300,
        child: Container(
          padding: EdgeInsets.only(left: 20),
          child: AppTextField(
            controller: numeroAf,
            keyboardType: TextInputType.text,
            validator: (text) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                  .valido(text, clearNoNumber: false);
            },
          ),
        ),
      ),
      actions: [cancelaButton, okButton],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  _defineDespesa(int idDespesa, int code) async {
    setState(() {
      loading = true;
    });
    var afbloc = Provider.of<AfBloc>(context, listen: false);
    await afbloc.ativaDespesa();

   // if (despesa > 0) {
      var cate = afAdd ?? AfAdd();
      cate.despesa = idDespesa;
      cate.codedespesa = code;
      cate.isdespesa = true;

      cate.status = Status.ordemAutorizada;
      await AfAddApi.save(context, cate);
      afbloc.decItensNovos(1);
      Provider.of<AfBloc>(context, listen: false)
          .fetchCode(context,widget.af.code);

   //   await _getContabilidade(idDespesa);

 //   }
    setState(() {
      loading = false;
    });
  }




}
