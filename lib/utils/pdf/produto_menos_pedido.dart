//Package imports
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// Render pdf with header and footer
class ProdutoMenosPedidoPdf extends StatefulWidget {
  /// Creates pdf with header and footer
  Key key;
  List<Estoque> list;
  ProdutoMenosPedidoPdf(this.key,this.list) : super(key: key);
  @override
  _ProdutoMenosPedidoPdfState createState() => _ProdutoMenosPedidoPdfState();
}

class _ProdutoMenosPedidoPdfState extends State<ProdutoMenosPedidoPdf> {
  _ProdutoMenosPedidoPdfState();

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

    //Draw the text
    final PdfSection section = document.sections.add();

    PdfGrid grid = PdfGrid();
//Add the columns to the grid
    grid.columns.add(count: 3);
//Add header to the grid
    grid.headers.add(2);
//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value= 'Lista de Produtos Menos Pedido';

    PdfGridRow header1 = grid.headers[1];
    header1.cells[0].value = 'Produto';
    header1.cells[1].value = 'Estoque';
    header1.cells[2].value = 'Unidade';


    header.cells[0].columnSpan = 3;
    header.height = 30;

//Add rows to grid
    for( var item in widget.list){
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = item.alias;
      row.cells[1].value = item.quantidade.toString();
      row.cells[2].value = item.unidade;

    }

    grid.columns[1].width = 60;
    grid.columns[2].width = 60;

    header1.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,));

    header.style = PdfGridRowStyle(
      textPen: PdfPens.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 18),
    );
    PdfStringFormat format2 = PdfStringFormat();
    format2.alignment = PdfTextAlignment.center;

    header.cells[0].stringFormat = format2;
    header.cells[0].style.borders = PdfBorders(
        left: PdfPen(PdfColor(255, 255, 255), width: 0),
        top: PdfPen(PdfColor(255, 255, 255), width: 0),
        bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
        right: PdfPen(PdfColor(255, 255, 255), width: 0));

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
        'Produtos menos Pedidos', PdfStandardFont(PdfFontFamily.helvetica, 10),
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
    js.context['filename'] = 'menos_pedido.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });
    document.dispose();
    //Launch file.

  }




}