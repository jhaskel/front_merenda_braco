
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/pages/setor/setor_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:provider/provider.dart';

import 'package:validadores/Validador.dart';

class SetorEdit extends StatefulWidget {
  final Setor setor;
  SetorEdit({this.setor}) : super();

  @override
  _SetorEditState createState() => _SetorEditState();
}

class _SetorEditState extends State<SetorEdit> {
  Setor get dados => widget.setor;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "setor_form");

  var _showProgress = false;

  final tNome = TextEditingController();


  bool _isativo;

  @override
  void initState() {
    //  Copia os dados  para o form
    if (dados != null) {
      tNome.text = dados.nome;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isativo = dados.isativo;
    return Scaffold(
      appBar: AppBar(
        title: Text(dados.nome),
        centerTitle: true,
        actions: [
          MergeSemantics(
            child: CupertinoSwitch(
              value: _isativo,
              onChanged: (bool newValue) {
                setState(() {
                  _isativo = newValue;
                });
                alteraStatus(newValue, dados);
              },
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    //  return Container(color: Colors.green,);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Editar  Setor", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da setor',
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),

                  SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    "Editar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }

  _onClickSalvar() async {
    final blocPage = Provider.of<PageBloc>(context);
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();
      var code = DateTime.now().hashCode;

      // Cria o usuario
      var nivel = dados ?? Setor();
      nivel.nome = tNome.text;
      nivel.modifiedAt = hoje;
      nivel.isativo = _isativo;
      ApiResponse<bool> response =
          (await SetorApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Setor editada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;

      });
      blocPage.setPage(AppPages.setor);

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Setor c) {
    final blocPage = Provider.of<PageBloc>(context);
    var cate = c ?? Setor();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    SetorApi.save(context, cate);

      blocPage.setPage(AppPages.setor);

  }
}
