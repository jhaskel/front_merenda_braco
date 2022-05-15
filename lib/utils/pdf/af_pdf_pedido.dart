//Package imports
import 'package:flutter/material.dart';

import 'package:merenda_escolar/app_model.dart';

import 'package:merenda_escolar/pages/entrega/Entrega.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:start_chart/chart/utils/date_format_util.dart';



///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';

/// Render pdf with header and footer
class AfPdfPedido extends StatefulWidget {
  /// Creates pdf with header and footer

  Pedido pedido;
  List<Entrega> list;
  List<String> dias;
  AfPdfPedido(this.pedido,this.list, this.dias);
  @override
  _AfPdfPedidoState createState() => _AfPdfPedidoState();
}

class _AfPdfPedidoState extends State<AfPdfPedido> {
  _AfPdfPedidoState();

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

    print("itens ${widget.list.length}");
    print("dias ${widget.dias}");
    double total = 0;

    for(var f in widget.list){
      total = total + f.quantidade*f.valor;

    }

    print("Prdicot ${total}");

    var formatador = NumberFormat("#,##0.00", "pt_BR");
    var totalGeral = total;
    print("totalG $totalGeral");
    DateTime crea = DateTime.parse(widget.pedido.createdAt);

    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    var listaFor = widget.list.map((e) => e.fornecedor).toSet().toList();
    print('jjkjk');
    //Create a new PDF document
    final PdfDocument document = PdfDocument();

    //Draw the text
    final PdfSection section = document.sections.add();

    PdfGrid grid = PdfGrid();
//Add the columns to the grid
    int colunas = 5;
    grid.columns.add(count: colunas);
//Add header to the grid
    grid.headers.add(2);
//Add the rows to the grid

    PdfGridRow header = grid.headers[0];
    header.cells[0].value= 'PEDIDO nº ${widget.pedido.id}';
    header.cells[1].value= '';
    header.cells[2].value= '';
    header.cells[3].value= '';
    header.cells[4].value= dataPedido;

    header.cells[0].columnSpan = 4;

    PdfGridRow header2 = grid.headers[1];
    header2.cells[0].value= '${widget.list.first.nomeescola}';
    header2.cells[0].columnSpan = 5;

    header.height = 30;
    header2.height = 30;

    print("1000 ${widget.dias}");

    for(var k in widget.dias){
      DateTime crea = DateTime.parse(k);
      print("2000");
      for(var forn in listaFor){
        print("3000");

        var kk = widget.list.where((e) => e.fornecedor == forn && e.dia==k && e.quantidade > 0);

        if(kk.length > 0){
          PdfGridRow row3 = grid.rows.add();
          row3.cells[0].value = "${forn} dia: ${DateFormat("dd/MM").format(crea)}";
          row3.cells[0].columnSpan = 5;
          row3.height = 30;
          print("3500");

          PdfGridRow row4 = grid.rows.add();
          row4.cells[0].value = 'Produto';
          row4.cells[1].value = 'Uni';
          row4.cells[2].value = 'Qde';
          row4.cells[3].value = 'Valor';
          row4.cells[4].value = 'Total';

          row3.style = PdfGridRowStyle(
              textPen: PdfPens.black,
              font: PdfStandardFont(PdfFontFamily.timesRoman, 12,));
          row4.style = PdfGridRowStyle(
              backgroundBrush: PdfBrushes.dimGray,
              textPen: PdfPens.white,
              textBrush: PdfBrushes.darkOrange,
              font: PdfStandardFont(PdfFontFamily.timesRoman, 12,));


        }


        print("3800");
//Add rows to grid
        for( var item in kk){
          print("4000");
          var valor = item.valor;
          var total = item.quantidade >0?item.valor*item.quantidade:0;

          PdfGridRow row = grid.rows.add();
          row.cells[0].value = item.alias;
          row.cells[1].value = item.unidade;
          row.cells[2].value = (item.quantidade).toStringAsFixed(1);
          row.cells[3].value = 'R\$ ${formatador.format(valor)}';
          row.cells[4].value = 'R\$ ${formatador.format(total)}';
        }
      }
    }


    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = 'Total do Pedido';
    row2.cells[1].value = '';
    row2.cells[2].value = '';
    row2.cells[3].value = '';
    row2.cells[4].value = 'R\$ ${formatador.format(totalGeral)}';
    row2.cells[0].columnSpan = 4;


    grid.columns[1].width = 35;
    grid.columns[2].width = 35;
    grid.columns[3].width = 70;
    grid.columns[4].width = 70;

    header2.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,));

    header.style = PdfGridRowStyle(
      textPen: PdfPens.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 18),
    );
    header2.style = header.style;

    //Add the styles to specific cell
    header.cells[4].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        );
    header2.cells[0].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );
    header.cells[4].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 12));
    header2.cells[0].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 12));

    PdfStringFormat format2 = PdfStringFormat();
    format2.alignment = PdfTextAlignment.center;


    header.cells[0].stringFormat = format2;
    header.cells[4].stringFormat = format2;

    header.cells[0].style.borders = PdfBorders(
        left: PdfPen(PdfColor(255, 255, 255), width: 0),
        top: PdfPen(PdfColor(255, 255, 255), width: 0),
        bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
        right: PdfPen(PdfColor(255, 255, 255), width: 0));


    header.cells[4].style.borders = header.cells[0].style.borders;
    header2.cells[0].style.borders = header.cells[0].style.borders;


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
        'PEDIDO - ${widget.pedido.id}', PdfStandardFont(PdfFontFamily.helvetica, 10),
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
    js.context['filename'] = 'pedido_for-${widget.list.first.ordem}.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });
    document.dispose();
    //Launch file.

  }




}
