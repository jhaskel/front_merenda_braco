
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_api.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/pages/widgets/required_label.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:validadores/Validador.dart';

class FornecedorAdd extends StatefulWidget {
  final Fornecedor fornecedor;

  FornecedorAdd({this.fornecedor}) : super();

  @override
  _FornecedorAddState createState() => _FornecedorAddState();
}

class _FornecedorAddState extends State<FornecedorAdd> {
  Fornecedor get fornecedor => widget.fornecedor;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "fornecedor_form");

  Email emailx;
  int _radioIndexArea = 0;
  bool _isativo;

  Color cor = Colors.white;

  var _showProgress = false;
  final tNome = TextEditingController();
  final tCnpj = TextEditingController();
  final tAlias = TextEditingController();
  final tBairro = TextEditingController();
  final tCidade = TextEditingController();
  final tCelular = TextEditingController();
  final tEmail = TextEditingController();

  @override
  void initState() {
    if (fornecedor != null) {
      tNome.text = fornecedor.nome;
      tCnpj.text = fornecedor.cnpj;
      tAlias.text = fornecedor.alias;     
      tCelular.text = fornecedor.celular;
      tEmail.text = fornecedor.email;
      _isativo = fornecedor.isativo;


    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BreadCrumb(
      actions: [
        fornecedor != null ? MergeSemantics(
          child: CupertinoSwitch(
            value:_isativo,
            onChanged: (bool newValue) {
              setState(() {
                _isativo = newValue;
              });
              alteraStatus(newValue,fornecedor);
            },
          ),
        ):Container(),
      ],
      child: body(),

    );
  }

  body() {
    return _cardForm();
  }

  _cardForm() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Cadastro de Fornecedores",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: AppTextField(
                      label: "Nome",
                      controller: tNome,
                      required: true,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RequiredLabel('CNPJ ou CPF', true),

                        TextFormField(
                          keyboardType: TextInputType.number,

                          textAlign: TextAlign.left,
                          controller: tCnpj,
                          validator: (text) {
                            return
                              Validador()
                                  .add(Validar.CNPJ, msg: 'CNPJ ou CPF Inválidos')
                                  .add(Validar.OBRIGATORIO,
                                  msg: 'Campo obrigatório')
                                  .minLength(11)
                                  .maxLength(14)
                                  .valido(text, clearNoNumber: true);
                          },

                          decoration: InputDecoration(
//        border: OutlineInputBorder(
//          borderRadius: BorderRadius.circular(16)
//        ),
//          labelText: label,
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color: AppColors.blue,
                            ),

                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),

                        )
                      ],

                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: AppTextField(
                      label: "Email",
                      required: true,
                      controller: tEmail,
                      keyboardType: TextInputType.text,
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
      String senha = r'$2a$10$HKveMsPlst41Ie2LQgpijO691lUtZ8cLfcliAO1DD9TtZxEpaEoJe';

      // Cria o usuario
      var forne = fornecedor ?? Fornecedor();
      forne.nome = tNome.text;
      forne.cnpj = tCnpj.text;
      forne.alias = tAlias.text;
      forne.celular = tCelular.text;
      forne.email = tEmail.text;
      forne.isativo = true;
      var td = 0;
      ApiResponse<bool> response = await FornecedorApi.save(context, forne);
        td = response.id;
      if (response.ok) {
         print(td);
        Usuario usuario;
        var user = usuario ?? Usuario();
        user.email = tEmail.text;
        user.nome = tNome.text;
        user.senha = senha;
        user.nivel = 6.toString();
        user.escola = td;
        user.created = hoje;
        user.isativo = true;
        user.login = tEmail.text;
        ApiResponse<bool> response = await UsuariosApi.save(context,user);

         if (response.ok) {
           Email emailx;
           var emaail = emailx ?? Email();
           emaail.nome = tNome.text;
           emaail.assunto = 'Novo Fornecedor';
           emaail.email= tEmail.text;
           emaail.content= 'Bem vindo ao sistema de Merenda Escolar do Municipio de Braço do Trombudo.Acesse com  ${tEmail.text} e com a senha 123';
           emaail.created= DateTime.now().toString();
           ApiResponse<bool> response = await EmailApi.save(emaail);

           alert(context, "Usuário salvo com sucesso", callback: () {
             Navigator.pushReplacementNamed(context, '/login');
           });
         } else {
//        alert(context, response.msg);
         }

        alert(context, "Fornecedor salva com sucesso", callback: () {
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

  void alteraStatus(bool newValue, Fornecedor c)  {
    var cate = c ?? Fornecedor();
    cate.isativo = newValue;
    FornecedorApi.save(context, cate);

  }




}
