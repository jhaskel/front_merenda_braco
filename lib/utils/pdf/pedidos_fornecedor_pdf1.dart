

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_bloc.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';

class PedidosFornecedorPdf1 extends StatefulWidget {
  List<PedidoItens> itens;

  PedidosFornecedorPdf1(this.itens);

  @override
  _PedidosFornecedorPdf1State createState() => _PedidosFornecedorPdf1State();

}

class _PedidosFornecedorPdf1State extends State<PedidosFornecedorPdf1> {

  final _blocFornec = FornecedorBloc();
  List<Fornecedor> fornec;

  @override
  void initState() {
    _blocFornec.fetchId(context,widget.itens.first.fornecedor);
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _blocFornec.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _blocFornec.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar o Fornecedor");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Fornecedor> listFornecedor= snapshot.data;
          Fornecedor fornecedor = listFornecedor.first;
          print('fornx${listFornecedor}');
          return PdfPreview(
            build: (format) => _generatePdf(format, widget.itens,fornecedor),
          );
        }
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    List<PedidoItens> itens, Fornecedor fornecedor
  ) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    var mapear = itens.map((e) => e.total);
    var total = mapear.reduce((a, b) => a+b);
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    DateTime crea = DateTime.parse(itens.first.created);

    doc.addPage(pw.MultiPage(
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
                  title: 'Lista de PedidosFornecedorPdf1',
                  child: pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text(fornecedor.nome, textScaleFactor: 1.2),

                            //      pw.PdfLogo()
                          ]),
                      pw.Text(itens.first.nomeescola, textScaleFactor: 1.0),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('Pedido: ', textScaleFactor: 1.0),
                            pw.Text( '${itens.first.pedido} ${DateFormat("dd/MM/yy").format(crea)}', textScaleFactor: 1),
                            //      pw.PdfLogo()
                          ]),
                    ]
                  )
                  ),
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
                            width: larg * .05,
                            child: pw.Text('cod',
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            width: larg * .55,
                            child: pw.Text('Produto',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            alignment: pw.Alignment.center,
                            width: larg * .05,
                            child: pw.Text('Qte'.toString(),
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            alignment: pw.Alignment.center,
                            width: larg * .05,
                            child: pw.Text('Unidade',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            alignment: pw.Alignment.centerRight,
                            width: larg * .15,
                            child: pw.Text('Preço'.toString(),
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            alignment: pw.Alignment.centerRight,
                            width: larg * .15,
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
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      PedidoItens p = itens[index];


                      return pw.LayoutBuilder(
                        builder: (context, constraints) {
                          double larg = constraints.maxWidth;
                          return pw.Column(children: [
                            pw.Row(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: larg * .05,
                                  child: pw.Text(p.cod.toString(),
                                      style: pw.TextStyle(fontSize: 8))),
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: larg * .55,
                                  child: pw.Text(p.alias,
                                      style: pw.TextStyle(fontSize: 10))),
                              pw.Container(
                                  alignment: pw.Alignment.center,
                                  width: larg * .05,
                                  child: pw.Text(p.quantidade.toString(),
                                      style: pw.TextStyle(fontSize: 10))),
                              pw.Container(
                                  alignment: pw.Alignment.center,
                                  width: larg * .05,
                                  child: pw.Text(p.unidade,
                                      style: pw.TextStyle(fontSize: 10))),
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: larg * .15,
                                  child: pw.Text('R\$ ${formatador.format(p.valor)}',
                                      style: pw.TextStyle(fontSize: 10))),
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: larg * .15,
                                  child: pw.Text('R\$ ${formatador.format(p.total)}',
                                      style: pw.TextStyle(fontSize: 10))),
                            ]),
                            pw.Divider(),
                          ]);
                        },
                      );
                    },
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Valor total'),
                      pw.Text('R\$ ${formatador.format(total)} ',style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold))
                    ]
                  )
                ]
              )


            ]));

    return await doc.save();
  }
}
