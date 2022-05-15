

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pro.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ProdutoMaisPedido extends StatelessWidget {
  List<Pro> list;
  ProdutoMaisPedido(this.list);
  var lista = new List<int>.generate(100, (i) => i + 1);
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: PdfPreview(
        build: (format) => _generatePdf(format, list,lista),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    List<Pro> itens, List<int> lista,


  ) async {
   // final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final doc = pw.Document();


    var formatador = NumberFormat("#,##0.00", "pt_BR");
    int y = itens.length;
    print('tmanho ${y}');
    int itera1 = y-24;
    print('itera1 ${itera1}');
    int itera2 = y-47;
    print('itera2 ${itera2}');
    int x = 23;
    int z = 2*x;

    List<Pro> list2;
    List<Pro> list3;
    List<Pro> list4;
    if(y > 23){
      list2 = itens.sublist(24,itera1<23?y:47);
    }
    if(y > 47){
      list3 = itens.sublist(48,itera2<23?y:71);
    }
    if(y > 71){
      list4 = itens.sublist(72,itera2<23?y:95);
    }



    print("tamanho ${itens.length}");
    print("tamanho2 ${list2.length}");

     doc.addPage(pw.MultiPage (
         pageFormat:
             PdfPageFormat.a4.copyWith(marginBottom: 1.0 * PdfPageFormat.cm),
         crossAxisAlignment: pw.CrossAxisAlignment.start,
         header: (pw.Context context) {
           if (context.pageNumber == 1) {
             return pw.SizedBox();
           }
           return pw.Container(
               alignment: pw.Alignment.centerRight,
               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
               decoration: const pw.BoxDecoration(
                   border: pw.Border(
                       bottom:
                           pw.BorderSide(width: 0.5, color: PdfColors.grey))),
               child: pw.Text('Lista de Pedidos Pdf',
                   style: pw.Theme.of(context)
                       .defaultTextStyle
                       .copyWith(color: PdfColors.grey)));
         },
         footer: (pw.Context context) {
           return pw.Container(
               alignment: pw.Alignment.centerRight,
               margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
               child: pw.Text(
                   'Page ${context.pageNumber} de ${context.pagesCount}',
                   style: pw.Theme.of(context)
                       .defaultTextStyle
                       .copyWith(color: PdfColors.grey)));
         },
    
    
         build: (pw.Context context) => <pw.Widget>[
               pw.Header(
                   level: 0,
                   title: 'Lista de ProdutoMaisPedido',
                   child: pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                       children: <pw.Widget>[
                         pw.Text('Produto Mais Pedidos: ', textScaleFactor: 1.5),
                         pw.Text( '${DateFormat("dd/MM/yy").format(DateTime.now())}', textScaleFactor: 1),

                       ])),
    

    
            pw.Column(
                 mainAxisAlignment: pw.MainAxisAlignment.center,
                 children: [
                   pw.Container(
                       color: PdfColors.brown50,
                       height: 30,
                       child:  pw.LayoutBuilder(
                   builder: (context, constraints) {
                     double larg = constraints.maxWidth;
                     return pw.Column(children: [
                       pw.Row(children: [
    
                         pw.Container(
                             alignment: pw.Alignment.centerLeft,
                             width: larg * .6,
                             child: pw.Text('Produto',
                                 style: pw.TextStyle(
                                     fontSize: 10,
                                     fontWeight: pw.FontWeight.bold))),
                         pw.Container(
                             alignment: pw.Alignment.center,
                             width: larg * .1,
                             child: pw.Text('Unidade',
                                 style: pw.TextStyle(
                                     fontSize: 10,
                                     fontWeight: pw.FontWeight.bold))),
                         pw.Container(
                             alignment: pw.Alignment.center,
                             width: larg * .1,
                             child: pw.Text('Qte'.toString(),
                                 style: pw.TextStyle(
                                     fontSize: 8,
                                     fontWeight: pw.FontWeight.bold))),
    
                         pw.Container(
                             alignment: pw.Alignment.centerRight,
                             width: larg * .2,
                             child: pw.Text('Total'.toString(),
                                 style: pw.TextStyle(
                                     fontSize: 10,
                                     fontWeight: pw.FontWeight.bold))),
                       ]),
    
                     ]);
                   },
                 ),
    
                   ),
    
                   pw.ListView.builder(
                     itemCount: list2.length,
                     itemBuilder: (context, index) {
                       Pro p = itens[index];
                       return pw.LayoutBuilder(
                         builder: (context, constraints) {
                           double larg = constraints.maxWidth;
                           return pw.Column(children: [
                             pw.Row(children: [
                               pw.Container(
                                   alignment: pw.Alignment.centerLeft,
                                   width: larg * .6,
                                   child: pw.Text(p.nome,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.unidade,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.quantidade.toString(),
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.centerRight,
                                   width: larg * .2,
                                   child: pw.Text('R\$ ${formatador.format(p.total)}',
                                       style: pw.TextStyle(fontSize: 10))),
                             ]),
                             pw.Divider(),
                           ]);

                         },
                       );
                     },
                   ),
                   y > 23? pw.ListView.builder(
                     itemCount: list2.length,
                     itemBuilder: (context, index) {
                       Pro p = list2[index];
                       return pw.LayoutBuilder(
                         builder: (context, constraints) {
                           double larg = constraints.maxWidth;
                           return pw.Column(children: [
                             pw.Row(children: [
                               pw.Container(
                                   alignment: pw.Alignment.centerLeft,
                                   width: larg * .6,
                                   child: pw.Text(p.nome,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.unidade,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.quantidade.toString(),
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.centerRight,
                                   width: larg * .2,
                                   child: pw.Text('R\$ ${formatador.format(p.total)}',
                                       style: pw.TextStyle(fontSize: 10))),
                             ]),
                             pw.Divider(),
                           ]);

                         },
                       );
                     },
                   ):pw.Container(),
                   y > 47? pw.ListView.builder(
                     itemCount: list3.length,
                     itemBuilder: (context, index) {
                       Pro p = list3[index];
                       return pw.LayoutBuilder(
                         builder: (context, constraints) {
                           double larg = constraints.maxWidth;
                           return pw.Column(children: [
                             pw.Row(children: [
                               pw.Container(
                                   alignment: pw.Alignment.centerLeft,
                                   width: larg * .6,
                                   child: pw.Text(p.nome,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.unidade,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.quantidade.toString(),
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.centerRight,
                                   width: larg * .2,
                                   child: pw.Text('R\$ ${formatador.format(p.total)}',
                                       style: pw.TextStyle(fontSize: 10))),
                             ]),
                             pw.Divider(),
                           ]);

                         },
                       );
                     },
                   ):pw.Container(),
                   y > 71? pw.ListView.builder(
                     itemCount: list4.length,
                     itemBuilder: (context, index) {
                       Pro p = list4[index];
                       return pw.LayoutBuilder(
                         builder: (context, constraints) {
                           double larg = constraints.maxWidth;
                           return pw.Column(children: [
                             pw.Row(children: [
                               pw.Container(
                                   alignment: pw.Alignment.centerLeft,
                                   width: larg * .6,
                                   child: pw.Text(p.nome,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.unidade,
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.center,
                                   width: larg * .1,
                                   child: pw.Text(p.quantidade.toString(),
                                       style: pw.TextStyle(fontSize: 10))),
                               pw.Container(
                                   alignment: pw.Alignment.centerRight,
                                   width: larg * .2,
                                   child: pw.Text('R\$ ${formatador.format(p.total)}',
                                       style: pw.TextStyle(fontSize: 10))),
                             ]),
                             pw.Divider(),
                           ]);

                         },
                       );
                     },
                   ):pw.Container(),
    
                 ]
               )
    
    
             ])
     );

    return await doc.save();
  }



}


