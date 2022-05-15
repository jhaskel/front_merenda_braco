import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:merenda_escolar/core/bloc/page_bloc.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_pages.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:validadores/Validador.dart';

class LicitacaoAdd extends StatefulWidget {
  final Licitacao licitacao;
  LicitacaoAdd({this.licitacao}) : super();

  @override
  _LicitacaoAddState createState() => _LicitacaoAddState();
}

class _LicitacaoAddState extends State<LicitacaoAdd> {
  Licitacao get licitacao => widget.licitacao;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "licitacao_form");

  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tProcesso = TextEditingController();
  final tEdital = TextEditingController();
  final tAno = TextEditingController();
  final tObjeto = TextEditingController();
  final tAlias = TextEditingController();
  final tValorFinal = TextEditingController();
  final tHomologado = TextEditingController();
  final tPrazo = TextEditingController();
  var datax;
  bool isativo;

  @override
  void initState() {
    if (licitacao != null) {
      tProcesso.text = licitacao.processo;
      tEdital.text = licitacao.edital;
      tAno.text = licitacao.ano.toString();
      tObjeto.text = licitacao.objeto;
      tAlias.text = licitacao.alias;
      tValorFinal.text = licitacao.valorfinal.toString();
      tHomologado.text = licitacao.homologadoAt;
      tPrazo.text = licitacao.prazo;
      tProcesso.text = licitacao.processo;
      isativo = licitacao.isativo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      actions: [
        licitacao != null ? MergeSemantics(
          child: CupertinoSwitch(
            value:isativo,
            onChanged: (bool newValue) {
              setState(() {
                isativo = newValue;
              });
              alteraStatus(newValue,licitacao);
            },
          ),
        ):Container(),
      ],
      child: _body(),
    );
  }

  _body() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Wrap(
                    children: [
                      Container(
                          width: 250,
                          child: AppTFF(
                            label: 'Processo Licitatório',
                            hint: '15/2021',
                            controller: tProcesso,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: false);
                            },
                          )),
                      Container(
                          width: 250,
                          child: AppTFF(
                            label: 'Edital',
                            hint: '36/2021',
                            controller: tEdital,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: false);
                            },
                          )),
                      Container(
                          width: 150,
                          child: AppTFF(
                            label: 'Ano',
                            hint: '2021',
                            controller: tAno,
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(text, clearNoNumber: true);
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: AppTFF(
                      maxLines: 6,
                      label: 'Objeto',
                      hint: 'Descrição do Objeto',
                      controller: tObjeto,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: AppTFF(
                      label: 'Resumo',
                      hint: 'Resumo do Objeto',
                      controller: tAlias,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: AppTFF(
                      label: 'Valor',
                      hint: '52.632,36',
                      controller: tValorFinal,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: true);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 250,
                          child: TextFormField(
                            controller: tHomologado,
                            decoration: InputDecoration(
                              labelText: "Data da Homologação",
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 6.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.green),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              //
                            ),
                            onTap: () async {
                              DateTime date = DateTime(1900);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 1),
                                  lastDate: DateTime(DateTime.now().year + 10));
                              datax = date.toIso8601String();
                              tHomologado.text =
                                  ('${date.day.toString()}/${date.month.toString()}/${date.year.toString()}');
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                            width: 250,
                            child: AppTFF(
                              label: 'Validade em dias',
                              hint: 'Ex.: 60',
                              controller: tPrazo,
                              validator: (text) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                        msg: 'Campo obrigatório')
                                    .valido(text, clearNoNumber: false);
                              },
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Dias'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppButton(
                    "Cadastrar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }

  _onClickSalvar() async {
    print("Cadastrar");
    final blocPage = Provider.of<PageBloc>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });


      var hoje = DateTime.now().toIso8601String();

      // Cria o usuario
      var nivel = licitacao ?? Licitacao();
      nivel.ano = int.parse(tAno.text);
      nivel.processo = tProcesso.text;
      nivel.edital = tEdital.text;
      nivel.objeto = tObjeto.text;
      nivel.alias = tAlias.text;
      nivel.valorfinal = double.parse(tValorFinal.text);
      nivel.homologadoAt = datax;
      nivel.prazo = tPrazo.text;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;
      nivel.isativo = true;

      ApiResponse<bool> response =
          (await LicitacaoApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Licitacao cadastrada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });
      blocPage.setPage(AppPages.licitacao);

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Licitacao c)  {
    print("novo status  = $newValue");
    var lici = c ?? Licitacao();
    lici.isativo = newValue;
    LicitacaoApi.save(context, lici);

  }
}
