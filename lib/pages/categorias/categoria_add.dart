
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_api.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:validadores/Validador.dart';

class CategoriaAdd extends StatefulWidget {
  final Categoria categoria;

  CategoriaAdd({this.categoria}) : super();

  @override
  _CategoriaAddState createState() => _CategoriaAddState();
}

class _CategoriaAddState extends State<CategoriaAdd> {
  Categoria get categoria => widget.categoria;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "categoria_form");

  Email emailx;
  int _radioIndexArea = 0;

  Color cor = Colors.white;

  var _showProgress = false;
  final tNome = TextEditingController();
  final tImagem = TextEditingController();




  @override
  void initState() {
    if (categoria != null) {
      tNome.text = categoria.nome;
      tImagem.text = categoria.image;

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BreadCrumb(
      child: body(),
      actions: categoria != null
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
                    "Cadastro Categorias",
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
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(text, clearNoNumber: false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: AppTextField(
                      label: "Url da imagem",
                      controller: tImagem,
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
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


      // Cria o usuario
      var cate = categoria ?? Categoria();
      cate.nome = tNome.text;
      cate.image = tImagem.text;

      ApiResponse<bool> response = await CategoriaApi.save(context, cate);

      if (response.ok) {
        alert(context, "Categoria salva com sucesso", callback: () {
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
