//Package imports
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:intl/intl.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:start_chart/chart/utils/date_format_util.dart';
///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';

import 'dart:js' as js;

/// Render pdf with header and footer
class LicitacaoPdfEstoque extends StatefulWidget {
  /// Creates pdf with header and footer
  
  List<Estoque> list;
  Licitacao licitacao;

  LicitacaoPdfEstoque(this.list,this.licitacao );
  @override
  _LicitacaoPdfEstoqueState createState() => _LicitacaoPdfEstoqueState();
}

class _LicitacaoPdfEstoqueState extends State<LicitacaoPdfEstoque> {
  _LicitacaoPdfEstoqueState();

  _gerar()async{
    await _generatePDF();
    PagesModel.get(context).pop();
  }


  @override
  void initState() {
    _gerar();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }

  Future<void> _generatePDF() async {
    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    widget.list.sort((a, b) => a.code.compareTo(b.code));
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    var tot = widget.list.map((e) => e.quantidade);
    var tota = tot.reduce((a, b) => a+b);
    var total = formatador.format(tota);
    DateTime crea = DateTime.parse(widget.list.first.createdAt);
    print('creax${crea}');
    print(' POPO ${widget.list}');
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    String hoje = DateFormat("dd/MM/yyyy").format(DateTime.now());

    //Draw the text
    final PdfSection section = document.sections.add();

    PdfGrid grid = PdfGrid();
//Add the columns to the grid
    grid.columns.add(count: 6);
//Add header to the grid
    grid.headers.add(4);
//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value= 'Processo nº  ${widget.licitacao.processo}';

    PdfGridRow headerFor = grid.headers[1];
    headerFor.cells[0].value= ' ${widget.licitacao.alias}';

    PdfGridRow headerCnpj = grid.headers[2];
    headerCnpj.cells[0].value= 'Merenda Escolar';

    PdfGridRow header1 = grid.headers[3];
    header1.cells[0].value = 'Cod';
    header1.cells[1].value = 'Produto';
    header1.cells[2].value = 'Uni';
    header1.cells[3].value = 'Licitado';
    header1.cells[4].value = 'Compras';
    header1.cells[5].value = 'Estoque';

    header.cells[0].columnSpan = 6;
    headerFor.cells[0].columnSpan = 6;
    headerCnpj.cells[0].columnSpan = 6;

    header.height = 30;
    headerFor.height = 25;
    headerCnpj.height = 25;

//Add rows to grid
    for( var item in widget.list){
      double estoque = item.quantidade;
      var comprado = item.comprado;
      if(comprado !=null){
        estoque  = ( item.quantidade - item.comprado);
      }else{
        comprado = 0;
      }

      PdfGridRow row = grid.rows.add();
      row.cells[0].value = item.code.toString();
      row.cells[1].value = item.alias;
      row.cells[2].value = item.unidade;
      row.cells[3].value = item.quantidade.toString();
      row.cells[4].value = comprado.toString();
      row.cells[5].value = estoque.toString();
    }



    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = '';
    row4.height = 30;

    row4.cells[0].columnSpan = 6;
    grid.columns[0].width = 35;
    grid.columns[2].width = 35;
    grid.columns[3].width = 50;
    grid.columns[4].width = 50;
    grid.columns[5].width = 50;

    header1.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,));

    header.style = PdfGridRowStyle(
      textPen: PdfPens.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 18),
    );

    header.cells[4].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,

        );

    header.cells[5].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 12));


    PdfStringFormat format2 = PdfStringFormat();
    format2.alignment = PdfTextAlignment.center;

    header.cells[0].stringFormat = format2;
    headerFor.cells[0].stringFormat = format2;
    headerCnpj.cells[0].stringFormat = format2;
    header1.cells[0].stringFormat = format2;
    header.cells[0].style.borders = PdfBorders(
        left: PdfPen(PdfColor(255, 255, 255), width: 0),
        top: PdfPen(PdfColor(255, 255, 255), width: 0),
        bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
        right: PdfPen(PdfColor(255, 255, 255), width: 0));
    header.cells[5].style.borders = header.cells[0].style.borders;
    headerFor.cells[0].style.borders = header.cells[0].style.borders;
    headerCnpj.cells[0].style.borders = header.cells[0].style.borders;
    row4.cells[0].style.borders = header.cells[0].style.borders;


//Set the grid style
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 4),
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

    //Create a PdfLayoutFormat for pagination
    PdfLayoutFormat format = PdfLayoutFormat(
        breakType: PdfLayoutBreakType.fitColumnsToPage,
        layoutType: PdfLayoutType.paginate);


//Draw the grid

    //Create a header template and draw a text.
    final PdfPageTemplateElement headerElement =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50), );
    headerElement.graphics.setTransparency(0.6);
    headerElement.graphics.drawString(
        'Processo-${widget.licitacao.processo}', PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle));
    headerElement.graphics
        .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
    section.template.top = headerElement;

    grid.draw(
      page: document.pages.add(),
      bounds: Rect.fromLTWH(0, 0, 0, 700),
      format: format,
    );



//Saves the document

    //Create a footer template and draw a text.
    final PdfPageTemplateElement footerElement =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50), );
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(text: 'Pag. {0} de {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.black),
      PdfPageCountField(brush: PdfBrushes.black)
    ]).draw(footerElement.graphics, const Offset(450, 35));
    section.template.bottom = footerElement;
    //Add a new PDF page

    //Save and dispose the document.
    final List<int> bytes = document.save();
    js.context['pdfData'] = base64.encode(bytes);
    js.context['filename'] = 'Licitacao-${widget.licitacao.processo}';
    Timer.run(() {
      js.context.callMethod('download');
    });
    document.dispose();
    //Launch file.
  }

}