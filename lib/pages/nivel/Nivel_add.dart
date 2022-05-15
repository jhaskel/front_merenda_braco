import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:validadores/Validador.dart';

class NivelAdd extends StatefulWidget {
  final Nivel nivel;
  NivelAdd({this.nivel}) : super();

  @override
  _NivelAddState createState() => _NivelAddState();
}

class _NivelAddState extends State<NivelAdd> {


  Nivel get nivell => widget.nivel;


  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: "nivel_form");

  Email emailx;
  int _radioIndexArea = 0;

  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tNome = TextEditingController();
  bool JSVal = true;
  bool tipo = true;
  String cpessoa = "CPF";
  String npessoa = "Nome";
  bool uploading = false;


  @override
  void initState() {
    // Copia os dados  para o form
    if (nivell != null) {
      tNome.text = nivell.nome;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      child: body(),
      actions: nivell != null
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
                    "Cadastro de Nivel Escolar",
                    style: Theme.of(context).textTheme.headline4,
                  ),
               SizedBox(
                    height: 50,
                  ),
                   Container(
                     padding: EdgeInsets.only(left: 20),
                     child: AppTextField(
                       label: "Nome",
                       controller: tNome,
                       keyboardType: TextInputType.text,
                       validator: (text) {
                         return  Validador()
                             .add(Validar.OBRIGATORIO,
                             msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: false);
                       },
                     ),
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

      var hoje = DateTime.now().toIso8601String();
      var code = DateTime.now().hashCode;


      // Cria o usuario
      var nive = widget.nivel ?? Nivel();
      nive.nome = tNome.text;
      nive.isativo = true;
      nive.created = hoje;

      ApiResponse<bool> response = await NivelApi.save(context,nive);

      if (response.ok) {
        alert(context, "Nivel salvo com sucesso", callback: () {
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
