import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/bloc/estoque_bloc.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/pdf/estoque_pdf_fornecedor.dart';
import 'package:merenda_escolar/utils/pdf/licitacao_pdf_estoque.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FornecedorDetalhe extends StatefulWidget {
  Fornecedor fornecedor;
   FornecedorDetalhe({this.fornecedor});

  @override
  _FornecedorDetalheState createState() => _FornecedorDetalheState();
}

class _FornecedorDetalheState extends State<FornecedorDetalhe> {

  Fornecedor get fornecedor =>widget.fornecedor;

  List<Estoque> lista;
  bool _isLoading = true;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  iniciaBloc() {
    Provider.of<EstoqueBloc>(context, listen: false).fetchFornecedor(context,fornecedor.id).then((
        _) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
  iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BreadCrumb(
        child: _body(),
        actions: [
          PrintButton(onPressed: () {
            _onClickEstoquePdf(lista);
          })

        ],
      ),
    );
  }

  _body() {
    final bloc = Provider.of<EstoqueBloc>(context);
    if (bloc.lista1.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista1.length == 0 && !_isLoading) {
      return Center(child: Text('Sem registros!'),);
    } else
      lista = bloc.lista1;
    return Column(
      children: [
        Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration:   BoxDecoration(
           border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(
          Radius.circular(20) //                 <--- border radius here
    ),
    ),

          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text('Nome:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                    ),
                    Flexible(
                        flex: 10,
                        fit: FlexFit.tight,
                        child: Text(fornecedor.nome,style: TextStyle(fontSize: 14),)
                    ),
                  ],

                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text('CNPJ:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                    ),
                    Flexible(
                        flex: 10,
                        fit: FlexFit.tight,
                        child: Text(fornecedor.cnpj,style: TextStyle(fontSize: 14),)
                    ),
                  ],

                )


              ],
            ),
          ),


        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: lista.length,
              itemBuilder: (context, index){
              Estoque c = lista[index];
              return _cardProduto(c);
              }
          
          ),
        ),
       

      ],

    );
  }
  _cardProduto(Estoque c) {
    double estoque;
    double comprado = 0.0;
    if(c.comprado !=null){
      estoque  = ( c.quantidade - c.comprado);
      comprado = c.comprado;
    }else{
      estoque  = ( c.quantidade - 0);
    }
    return Column(
      children: [
        ListTile(
          onTap: () {
            //   _onClickProduto(c);
          },
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c.alias),
              c.agrofamiliar
                  ? Icon(Icons.check_circle,color: Colors.green,)
                  : Container(),
              Spacer(),
              text('R\$ ${formatador.format(c.valor)}' ?? "",),
              SizedBox(width: 10,),
              Text(c.unidade),

            ],

          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Text('Licitado: '),
                Text(c.quantidade.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 30,),
                Text('Comprado: '),
                Text(comprado.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
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

        ),
        Divider(thickness: 2,)
      ],

    );
  }

  _onClickEstoquePdf(List<Estoque> lista) {
    PagesModel.get(context)
        .push(PageInfo("Imprimir", EstoquePdfFornecedor(lista,fornecedor)));
  }
}
