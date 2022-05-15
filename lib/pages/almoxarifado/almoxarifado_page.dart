import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/almoxarifado_bloc.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/widgets/print_button.dart';
import 'package:merenda_escolar/pages/widgets/text.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/pdf/dispensa_pdf.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:merenda_escolar/web/utils/web_utils.dart';
import 'package:provider/provider.dart';

class AlmoxarifadoPage extends StatefulWidget {
  Usuario user;
   AlmoxarifadoPage(this.user);

  @override
  _AlmoxarifadoPageState createState() => _AlmoxarifadoPageState();
}


class _AlmoxarifadoPageState extends State<AlmoxarifadoPage> {
  List<Almoxarifado> listaAlmoxarifado = [];
  bool _isLoading = true;
  final tQuantidade = TextEditingController();
  iniciaBloc() {
    Provider.of<AlmoxarifadoBloc>(context, listen: false)
        .fetchEscola(context, widget.user.escola)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }
  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      child: _body(),
      actions: [
        PrintButton(onPressed: (){
          _onClickImprimir();
        })
      ],
    );

  }

  _body() {
    return LayoutBuilder(builder: (context, constraints) {
      int columns = _columns(constraints);
      return dispensa(columns);
    });

  }
  int _columns(constraints) {
    int columns = constraints.maxWidth > 800 ? 6 : 3;
    if (constraints.maxWidth <= 500) {
      columns = 1;
    }
    return columns;
  }

  dispensa(int columns) {
    final bloc = Provider.of<AlmoxarifadoBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      listaAlmoxarifado = bloc.lista;
    listaAlmoxarifado = listaAlmoxarifado.where((e) => e.quant >0).toList();
    var escolas = listaAlmoxarifado.map((e) => e.nomeescola).toSet().toList();

    print(listaAlmoxarifado.length);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: .7,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemCount: listaAlmoxarifado.length,
      itemBuilder: (context, index) {
        Almoxarifado c = listaAlmoxarifado[index];
        return LayoutBuilder(
          builder: (context, constraints) {
            double font = constraints.maxWidth * 0.06;

            return _cardAlmoxarifado(c, font);
          },
        );
      },
    );
  }

  _cardAlmoxarifado(Almoxarifado c, double font) {

  return  Card(
    elevation: 5,
    child: InkWell(
      onTap: () {
        // _onClickProduto(c);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.lightBlueAccent,
                child: IconButton(
                    icon: Icon(
                      Icons.compare_arrows,
                      size: 15,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDecrement(context,c);
                    }),
              )
            ],
          ),
          Container(
            child: Center(
              child: text(c.alias ?? "",
                  fontSize: fontSize(font),
                  maxLines: 4,
                  ellipsis: true,
                  bold: true,
                  color: Colors.black87),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: Text(
                  "Em estoque: ",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  child: Container(
                    child: Text(
                      c.quant.toString() ?? "",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: text(
                    c.unidade ?? "",
                    fontSize: fontSize(font),
                    maxLines: 1,
                    ellipsis: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );


  }
  showDecrement(BuildContext context,Almoxarifado c) async {

    Widget comprarButton = MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Atualizar",
              style: AppTextStyles.heading15White,
            )
          ],
        ),
      ),
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      onPressed: () async {
        String quanti = tQuantidade.text;
        int quantidad;
        if (quanti != "") {
          quantidad = int.parse(quanti);
          if(quantidad > c.quant){
            toast(context, "Quantidade máx ${c.quant}");
          }else{
            pop(context);
            _onClickSalvar(context, c);

          }
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text(
                  c.alias,
                  style: AppTextStyles.heading15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: AppColors.primaria,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    c.unidade,
                    style: AppTextStyles.body11White,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  Container(
                    child: Text(
                      'Estoque: ',
                      style: AppTextStyles.body11,
                    ),
                  ),
                  Container(
                    child: Text(
                      c.quant.toString(),
                      style: TextStyle(fontSize: 20,color: Colors.blue),
                    ),
                  ),
                ],

              ),
            ),
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
            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: comprarButton,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Descrição', style: AppTextStyles.bodyTitleBold)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 300,
                  child: Text(
                    c.alias,
                    style: AppTextStyles.body11,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  )),
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
        return Container(
          width: 300,
          height: 600,
          child: alert,
        );
      },
    );
  }

  Future<void> _onClickSalvar(BuildContext context, Almoxarifado c) async {

    AlmoxarifadoAd almoxarifadoAd;

    var x = tQuantidade.text;
    var bloc = Provider.of<AlmoxarifadoBloc>(context,listen: false);
    

    var produ = almoxarifadoAd ?? AlmoxarifadoAd();
    produ.produto= c.produto;
    produ.licitacao = c.licitacao;
    produ.escola = c.escola;
    produ.alias = c.alias;
    produ.quantidade = int.parse(x)*-1;
    produ.unidade = c.unidade;
    produ.categoria = c.categoria;
    produ.nomeescola = c.nomeescola;
    produ.created = DateTime.now().toIso8601String();
    produ.isativo = true;

    ApiResponse<bool> response = await AlmoxarifadoAdApi.save(context, produ);

    if (response.ok) {

      bloc.fetchEscola(context,widget.user.escola);

      alert(context, "Almoxarifado atualizado com sucesso", callback: () {
        

      });
    } else {
      alert(context, response.msg);
    }

  }

  void _onClickImprimir() {
    PagesModel.get(context)
        .push(PageInfo("Imprimir", DispensaPdf(listaAlmoxarifado)));

  }


}
