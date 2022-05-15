import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/entrega_bloc.dart';
import 'package:merenda_escolar/core/bloc/itens_bloc.dart';
import 'package:merenda_escolar/models/itens.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/entrega/Entrega.dart';
import 'package:merenda_escolar/pages/entrega/entrega_api.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/nav.dart';

import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';


class OrdemFornecedor extends StatefulWidget {
  List<PedidoItens> list;
  String nomeFor;
  Af af;
  OrdemFornecedor(this.list, this.nomeFor,this.af );


  @override
  _OrdemFornecedorState createState() => _OrdemFornecedorState();
}

class _OrdemFornecedorState extends State<OrdemFornecedor> {
  List<Itens> listFor;
  final tQuantidade = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  Entrega entrega;
  List<Entrega> listEntrega = [];
  bool _isLoading = true;
  bool _showProgress = false;
  double totalOrdem =0;
  TextEditingController diaa = TextEditingController();
  int quant =0;
  List<String> dias = [];
  int step;
  int currentStep = 0;
  bool _isRealizado = false;
  var datax;
  DateTime dtCrea;
  DateTime dtAge;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  iniciaBloc() {
    Provider.of<EntregaBloc>(context, listen: false).fetchOrdem(context,widget.af.code).then((value) {
      setState(() {
        _isLoading = false;
       if(value !=null){
         _isRealizado = true;
       }
      });

    });

  }
  montaPlanilha() async {

    //   dias.sort((a, b) => a.toString().compareTo(b.toString()));

    final blocEntrega = Provider.of<EntregaBloc>(context,listen: false);
    quant = dias.length;


    blocEntrega.clearr();
    print("primeira vez");
    print("entrou no loop $dias");
    for (var j in dias) {
      for (var t in widget.list) {
        var jk = entrega ?? Entrega();
        jk.ordem = t.af;
        jk.pedido = t.pedido;
        jk.escola = t.escola;
        jk.dia = j;
        jk.alias = t.alias;
        jk.produto = t.produto;
        jk.unidade = t.unidade;
        jk.fornecedor = widget.nomeFor;
        jk.quantidade = t.quantidade/quant;
        jk.valor = t.valor;
        jk.nomeescola = t.nomeescola;
        jk.isrecebido = false;
        jk.licitacao = t.licitacao;
        jk.categoria = t.categoria;
        blocEntrega.add(jk);
      }
    }

  }


  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }

  @override
  Widget build(BuildContext context) {
      print("iniciando 01 ${_isRealizado}");
      print("quant dias = $quant");
      print("DUUUU $dias");
      final blocEntrega = Provider.of<EntregaBloc>(context);
      if (blocEntrega.lista.length == 0 && _isLoading) {
        return Center(child: CircularProgressIndicator());
      } else if(blocEntrega.lista.length == 0 && !_isLoading) {
        step = blocEntrega.lista.length;
        print("step $step");

        return Scaffold(
          body: BreadCrumb(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextError('Sem registros!'),
                  SizedBox(height: 30,),
                  MaterialButton(
                    onPressed: () {
                      showBottomSheet(context);
                    },
                    color: Colors.blue,
                    child: Text("Adicionar dias de Entrega"),

                  )

                ],)

          ),

        );
      } else {

          print("iniciando 02");
          listEntrega = blocEntrega.lista;
          step=listEntrega.length;
          print(listEntrega);
          print("iniciando 02 $dias");
          return Scaffold(
            body: BreadCrumb(
              child: Stack(
                children: [
                  _body(blocEntrega),
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


                actions: [
                  PrintButton(onPressed: (){
                    _isRealizado?_onClickImprimir():alert(context,"Você precisa salvar a lista");
                  })
                ],

            ),
            bottomNavigationBar: !_isRealizado?salvarButton():imprimirButton(),
          );

      }

  }

  _body(EntregaBloc blocEntrega) {
    print("iniciando 03");


    print("itee ${blocEntrega.lista.length}");
    var formatador = NumberFormat("#,##0.00", "pt_BR");

    DateTime crea = DateTime.parse(widget.list.first.created);
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    print("dataPedido ${dataPedido}");
    var jj = listEntrega.map((e) => e.nomeescola).toSet().toList();
    var getDias = listEntrega.map((e) => e.dia).toSet().toList();
    print("jj ${jj.length}");
    List<PedidoItens> o = [];
    var quant = getDias.length;
    print("quantX $quant");

    print("LIST FINAL ${blocEntrega.lista.length}");
    print("LIST forn ${listEntrega.length}");
    //listEntrega.sort((a, b) => a.dia.compareTo(b.dia));

    return ListView.builder(
        itemCount: jj.length,
        itemBuilder: (context, index) {
          var largura = MediaQuery.of(context).size.width-280;
          var h =
          listEntrega.where((e) => e.nomeescola == jj[index]).toList();
          h.sort((b, a) => a.produto.compareTo(b.produto));
          print('Escola ${jj[index]} ${h.length}');
          return Container(
            height: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Escola ${jj[index]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(

                            child: Text('Produto',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            width: largura*.8,


                          ),
                          Container(

                            child: Text('Dia da Entrega',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            width: largura*.1,
                          ),
                          Container(

                            child: Text('Quantidade',textAlign: TextAlign.end,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            width: largura*.1,
                          ),

                        ],
                      ),
                    )


                  ],

                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: h.length,
                      itemBuilder: (context, index) {
                        Entrega l = h[index];

                        DateTime crea = DateTime.parse(l.dia);
                        return Container(
                          height: 55,
                          child: Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(l.alias),
                                      width: largura*.8,
                                    ),

                                    Container(
                                      child: Text(DateFormat("dd/MM").format(crea),textAlign: TextAlign.center,),
                                      width: largura*.1,

                                    ),
                                    Container(
                                        width: largura*.1,
                                        height: 18,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: quant==1||_isRealizado
                                              ?Text(l.quantidade.toStringAsFixed(2),textAlign: TextAlign.end,)
                                              :TextFormField(
                                            decoration: new InputDecoration(
                                              contentPadding: EdgeInsets.all(5.0),

                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),

                                            initialValue: l.quantidade.toStringAsFixed(2),
                                            onChanged: (value) {
                                              int indexx = blocEntrega.lista.indexOf(l);

                                              setState(() {
                                                l.quantidade = double.parse(value) ;
                                                blocEntrega.alteraQuant(indexx,double.parse(value));
                                              });
                                           //   update(l,l.quantidade);

                                            },


                                          ),
                                        )

                                    ),



                                 /*   Container(
                                        width: largura*.2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text('${(l.quantidade).toStringAsFixed(2)}',textAlign: TextAlign.end,),
                                        )

                                    )*/
                                  ],
                                ),
                              ),

                              Divider(
                                thickness: 1.2,
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
  showAlterar(BuildContext context, int indexx, ItensBloc bloc) async {
    tQuantidade.clear();
    Widget comprarButton = MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Alterar Quantidade",
          style: AppTextStyles.heading15White,
        ),
      ),
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      onPressed: () async {
        String quant = tQuantidade.text;
        double quantidade;
        if (quant != "") {
          quantidade = double.parse(quant);
          bloc.alteraQuant(indexx,quantidade);
            pop(context);
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
              padding: const EdgeInsets.all(10.0),
              child: comprarButton,
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

  Widget salvarButton() {
    return MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Salvar Lista",
            style: AppTextStyles.heading15White,
          ),
        ),
        color: AppColors.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        onPressed: () {
          salvaDados();
        }

    );
  }
  Widget imprimirButton() {
    return MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Imprimir",
            style: AppTextStyles.heading15White,
          ),
        ),
        color: AppColors.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        onPressed: () {
          _onClickImprimir();
        }

    );
  }


  _onClickImprimir() async {
    var days = listEntrega.map((e) => e.dia).toSet().toList();
    for (var x in days){
      dias.add(x);
    }
    print("dias $dias");
 /*   await PagesModel.get(context)
        .push(PageInfo("Imprimir", AfPdfEscola(listEntrega, widget.nomeFor,dias,widget.af)));*/

  }
  salvaDados() async{
    setState(() {
     _showProgress  = true;
      _isRealizado = true;

    });
    for(var v in listEntrega){
      await  EntregaApi.save(context, v);
      setState(() {
        currentStep++;
      });
    }
    setState(() {
      _showProgress  = false;
    });

  }

  Future<void> update(Entrega l, double quantidade) async {
    var jk = l ?? Entrega();
    jk.quantidade = quantidade;
    await EntregaApi.save(context, jk);
  }
  showBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: 500,
            child: Padding(
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
                          child: MaterialButton(
                              color: Colors.blue,
                              child: Text('Adicionar',style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                DateTime date = DateTime(1900);
                                FocusScope.of(context).requestFocus(new FocusNode());

                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2023));
                                datax = date.toIso8601String();
                                diaa.text = ('${date.day.toString()}/${date.month.toString()}');
                                setState(() {
                                  dias.add(datax);
                                  print(dias);
                                });
                              }),
                        ),
                        Container(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: dias.length,
                              itemBuilder: (context, index) {
                                DateTime crea = DateTime.parse(dias[index]);

                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      dias.remove(dias[index]);
                                    });

                                  },
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Chip(
                                      label: Text(DateFormat("dd/MM").format(crea),style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
                                  ),
                                );
                              }
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          child: dias.length>0?MaterialButton(
                            onPressed: () async {
                               montaPlanilha();
                              pop(context);
                            },
                            color: Colors.green,
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
            ),
          );
        }
        );
  }

}

