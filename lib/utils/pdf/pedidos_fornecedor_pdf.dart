//Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';


///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:intl/intl.dart';

/// Render pdf with header and footer
class PedidosFornecedorPdf extends StatefulWidget {
  /// Creates pdf with header and footer
  Key key;
  List<PedidoItens> list;
  String nomeFor;
  PedidosFornecedorPdf(this.key,this.list, this.nomeFor) : super(key: key);
  @override
  _PedidosFornecedorPdfState createState() => _PedidosFornecedorPdfState();
}

class _PedidosFornecedorPdfState extends State<PedidosFornecedorPdf> {
  _PedidosFornecedorPdfState();

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
    var formatador = NumberFormat("#,##0.00", "pt_BR");
    var tot = widget.list.map((e) => e.total);
    var tota = tot.reduce((a, b) => a+b);
    var total = formatador.format(tota);
    DateTime crea = DateTime.parse(widget.list.first.created);
    print('creax${crea}');
    String dataPedido = DateFormat("dd/MM/yyyy").format(crea);
    print('creaxx${dataPedido}');

    //Create a new PDF document
    final PdfDocument document = PdfDocument();

    //Draw the text
    final PdfSection section = document.sections.add();

    PdfGrid grid = PdfGrid();
//Add the columns to the grid
    grid.columns.add(count: 5);
//Add header to the grid
    grid.headers.add(3);
//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value= widget.list.first.pedido;
    header.cells[1].value= '';
    header.cells[2].value= '';
    header.cells[3].value= '';
    header.cells[4].value= dataPedido;

    PdfGridRow header2 = grid.headers[1];
    header2.cells[0].value= '${widget.nomeFor}';


    PdfGridRow header1 = grid.headers[2];
    header1.cells[0].value = 'Produto';
    header1.cells[1].value = 'Uni';
    header1.cells[2].value = 'Qde';
    header1.cells[3].value = 'Valor';
    header1.cells[4].value = 'Total';

    header.cells[0].columnSpan = 4;
    header2.cells[0].columnSpan = 5;

    header.height = 30;
    header2.height = 30;

//Add rows to grid
    for( var item in widget.list){
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = item.alias;
      row.cells[1].value = item.unidade;
      row.cells[2].value = item.quantidade.toString();
      row.cells[3].value = 'R\$ ${formatador.format(item.valor)}';
      row.cells[4].value = 'R\$ ${formatador.format(item.total)}';
    }
    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = 'Total do Pedido';
    row2.cells[1].value = '';
    row2.cells[2].value = '';
    row2.cells[3].value = '';
    row2.cells[4].value = 'R\$ ${total}';
    row2.cells[0].columnSpan = 4;

    grid.columns[1].width = 35;
    grid.columns[2].width = 35;
    grid.columns[3].width = 70;
    grid.columns[4].width = 70;

    header1.style = PdfGridRowStyle(
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
        lineAlignment: PdfVerticalAlignment.bottom,
        wordSpacing: 10);
    header.cells[4].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 12));



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


//Set the column text format

//Set the column text format



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
        'Fornecedor', PdfStandardFont(PdfFontFamily.helvetica, 10),
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
    js.context['filename'] = 'for-${widget.list.first.pedido}.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });
    document.dispose();
    //Launch file.

  }




}