//Package imports
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';
import 'package:merenda_escolar/pages/pro.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/utils/nav.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// Render pdf with header and footer
class OficioPdf extends StatefulWidget {
  /// Creates pdf with header and footer

  String processo;
  Af af;
  Contabilidade conta;
  String data;
  double total;
  int despesa;

  OficioPdf(this.processo,this.af,this.conta,this.data,this.total,[this.despesa ]);
  @override
  _OficioPdfState createState() => _OficioPdfState();
}

class _OficioPdfState extends State<OficioPdf> {

  _OficioPdfState();

  _gerar()async{
    await _generatePDF();
    PagesModel.get(context).pop();

  }

  @override
  void initState() {
    print("KKKKKKKKKKKK");
    print(' ${widget.processo} - ${widget.af} - ${widget.conta} - ${widget.data}  - ${widget.total.toString()}, ${widget.despesa}');
    _gerar();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }

  Future<void> _generatePDF() async {
    pop(context);
    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    print('creax${widget.data}');
    await Jiffy.locale("pt/pt_br");
    String dt = Jiffy(widget.data).yMMMMd;

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final PdfFont tituloFont = PdfStandardFont(PdfFontFamily.helvetica, 16,style: PdfFontStyle.bold);
    final PdfFont despesaFont = PdfStandardFont(PdfFontFamily.helvetica, 13,style: PdfFontStyle.bold);
    const String address =
        'Ao Senhor(a) \r\n$RESPONSAVEL_SETOR, \r\n$SETOR \r\nPrefeitura Municipal de $CIDADE/SC';
    String data = '$CIDADE em ${dt}';
    String corpo =
        'Com nossos  cordiais cumprimentos, temos a grata satisfação de nos dirigirmos a vossa senhoria, para solicitar aquisição de mercadoria, conforme Processo Licitatório nº ${widget.processo}';
    const String titulo = 'SOLICITAÇÃO DE COMPRA';
    String orgao = 'Órgão - ${widget.conta.orgao.toString()}  ${widget.conta.nomeOrgao}';
    String despesa = 'Despesa -  ${widget.conta.cod.toString()}';
    String elemento = 'Elemento -  ${widget.conta.elemento}';
    const String linha = '_______________________________________';
    const String nomeresp = '$RESPONSAVEL';
    const String cargoresp = '$CARGO_RESPONSAVEL';
    //Draw the 0
    document.pages.add().graphics.drawString(
        address, contentFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 70, 300, 50)
    );

    PdfPage page1 = document.pages[0];

    page1.graphics.drawString( data, contentFont, bounds: Rect.fromLTWH(0, 150, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.right,
    ));
    page1.graphics.drawString( titulo, tituloFont, bounds: Rect.fromLTWH(0, 200, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
    ));
    page1.graphics.drawString( corpo, contentFont, bounds: Rect.fromLTWH(0, 250, 500, 0),format: PdfStringFormat(
        paragraphIndent: 35));
    //vem a tabela
    page1.graphics.drawString( orgao, despesaFont, bounds: Rect.fromLTWH(0, 380, 500, 0));
    page1.graphics.drawString( despesa, despesaFont, bounds: Rect.fromLTWH(0, 400, 500, 0));
    page1.graphics.drawString( elemento, despesaFont, bounds: Rect.fromLTWH(0, 420, 500, 0));
    page1.graphics.drawString( linha, contentFont, bounds: Rect.fromLTWH(0, 550, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,

    ));
    page1.graphics.drawString( nomeresp, contentFont, bounds: Rect.fromLTWH(0, 565, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
    ));
    page1.graphics.drawString( cargoresp, contentFont, bounds: Rect.fromLTWH(0, 580, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
    ));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 6);
//Add header to the grid
    grid.headers.add(1);

//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Item';
    header.cells[1].value = 'Quant.';
    header.cells[2].value = 'Unid.';
    header.cells[3].value = 'Descrição';
    header.cells[4].value = 'Valor Unit.';
    header.cells[5].value = 'Total';

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '01';
    row.cells[1].value = '01';
    row.cells[2].value = 'Unid';
    row.cells[3].value = 'Af  ${widget.af.code}';
    row.cells[4].value = '';
    row.cells[5].value = 'R\$ ${formatador.format(widget.total)}';

    grid.columns[0].width = 35;
    grid.columns[1].width = 40;
    grid.columns[2].width = 35;
    grid.columns[4].width = 70;
    grid.columns[5].width = 70;


//Set the grid style
    header.cells[3].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );

    header.style = PdfGridRowStyle(

        backgroundBrush: PdfBrushes.lightGray,
        textPen: PdfPens.black,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,)
    );

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

//Draw the grid
    grid.draw(
        page: page1, bounds: const Rect.fromLTWH(0, 300, 0, 0));



    //Save and dispose the document.
    final List<int> bytes = document.save();
    js.context['pdfData'] = base64.encode(bytes);
    js.context['filename'] = 'Of-${widget.af.code}';
    Timer.run(() {
      js.context.callMethod('download');
    });
    document.dispose();
    //Launch file.
  }





}