
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:merenda_escolar/core/app_colors.dart';
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

class SetorAdd extends StatefulWidget {
  final Setor setor;
  SetorAdd({this.setor}) : super();

  @override
  _SetorAddState createState() => _SetorAddState();
}

class _SetorAddState extends State<SetorAdd> {
  Setor get setor => widget.setor;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "setor_form");


  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tNome = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    final blocPage = Provider.of<PageBloc>(context);
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaria,
                        ),
                        onPressed: () {
                          blocPage.setPage(AppPages.setor);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Cadastro de Setors",
                          style: AppTextStyles.title),
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

                  AppButton(
                    "Cadastrar",
                    onPressed: _onClickSalvar(blocPage),
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }

  _onClickSalvar(PageBloc blocPage) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();

      // Cria o usuario
      var nivel = setor ?? Setor();
      nivel.nome = tNome.text;

      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response =
          (await SetorApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Setor cadastrada com sucesso", callback: () {});
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
}
