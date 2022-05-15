
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';
import 'package:merenda_escolar/pages/pnae/Pnae_api.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:validadores/Validador.dart';

class PnaeAdd extends StatefulWidget {
  final Pnae pnae;

  PnaeAdd({this.pnae}) : super();

  @override
  _PnaeAddState createState() => _PnaeAddState();
}

class _PnaeAddState extends State<PnaeAdd> {
  Pnae get pnae => widget.pnae;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "pnae_form");

  Email emailx;
  int _radioIndexArea = 0;

  Color cor = Colors.white;

  var _showProgress = false;
  final tValor = TextEditingController();





  @override
  void initState() {
    if (pnae != null) {
      tValor.text = pnae.valor.toString();


    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BreadCrumb(
      child: body(),
      actions: pnae != null
          ? [
              DeleteButton(
                  //    onPressed: _onClickDelete,
                  )
            ]
          : null,
    );
  }

  body() {
    return _cardForm();
  }

  _cardForm() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Cadastro de Unidades escolares",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: AppTextField(
                      label: "Valor",
                      controller: tValor,
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: true);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Divider(
                    height: 10.0,
                  ),
                  AppButton(
                    "Salvar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;


      });

      String val = tValor.text;
      double valor;
      if(val.contains(',')){
        val = val.replaceAll(".", "");
        val = val.replaceAll(",", ".");
        valor = double.parse(val);
      }else{
        valor = double.parse(val);
      }

      var hoje = DateTime.now().toIso8601String();
      var ano = DateTime.now().year;


      // Cria o usuario
      var cate = pnae ?? Pnae();
      cate.valor = valor;
      cate.created = hoje;
      cate.ano = ano;

      ApiResponse<bool> response = await PnaeApi.save(context, cate);

      if (response.ok) {
        alert(context, "Pnae salva com sucesso", callback: () {
          PagesModel.get(context).pop();
        });
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });

      print("Fim.");
    }
  }




}
