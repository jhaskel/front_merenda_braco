
import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_bloc.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:search_page/search_page.dart';
import 'package:validadores/Validador.dart';

class UsuarioFormPage extends StatefulWidget {
  final Usuario usuario;

  UsuarioFormPage({this.usuario}) : super();

  @override
  _UsuarioFormPageState createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {

  final _bloc = UnidadeEscolarBloc();
  List<UnidadeEscolar> nivelEscolar;


  Usuario get usuario => widget.usuario;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "usuario_form");

  var _showProgress = false;
  final tNome = TextEditingController();
  final tEmail = TextEditingController();
  final tlogin = TextEditingController();
  final tTipo = TextEditingController();
  final tNivel = TextEditingController();
  int _radioIndex = 0;

  bool uploading = false;


  int idEscola;
  String nomeEscola = '';

  @override
  void initState() {
    super.initState();

    _bloc.fetch(context,false);

    // Copia os dados do usuario para o form
    if (usuario != null) {
      tNome.text = usuario.nome;
      tEmail.text = usuario.email;
     _radioIndex = getTipoInt(usuario);
    }
  }

  // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do usuario.';
    }

    return null;
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Informe o email.';
    }

    return null;
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tNivel.text = nomeEscola;

    return BreadCrumb(
      child: body(),
      actions: usuario != null
          ? [

            ]
          : null,
    );
  }
  body() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _cardForm(),
        )
      ],
    );
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Usuario usuario) {
    switch (usuario.nivel) {
      case 'Escola':
        return 0;
      case "Gerente":
        return 1;
      case "master":
        return 2;
      default:
        return 0;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return Niveis.unidade;
        break;
      case 1:
        return Niveis.admin;
        break;
      case 2:
        return Niveis.master;
        break;
      default: 4;

    }
  }

  _cardForm() {
    return Card(
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar as escolas");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<UnidadeEscolar> listEscolas = snapshot.data;
          return Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Nível",
//              textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _radioTipo(),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    label: "Nome",
                    controller: tNome,
                    required: true,
                    validator: _validateNome,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    label: "Email",
                    required: true,
                    controller: tEmail,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                 _radioIndex == 0  ? Container(
                   child: InkWell(
                onTap: (){_unidadeEscolar(context, listEscolas);},
            child: AppTextField(
              label: "Escola",
              controller: tNivel,
              keyboardType: TextInputType.text,
              enabled: false,
              required: true,
              validator: (text) {
                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                      .valido(text, clearNoNumber: false);
              },
            ),
          ),
                 ):Container(),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      AppButton(
                        "Cancelar",
                        onPressed: _onClickCancelar,
                        whiteMode: true,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      AppButton(
                        "Salvar",
                        onPressed: _onClickSalvar,
                        showProgress: _showProgress,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  _radioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.escola,
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.gerente,
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.master,
          style: TextStyle(color: AppColors.blue, fontSize: 14),
        ),

      ],
    );
  }


  _onClickSalvar() async {
    print("CADASTRANDO>>>");
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();
      String senha = r'$2a$10$HKveMsPlst41Ie2LQgpijO691lUtZ8cLfcliAO1DD9TtZxEpaEoJe';
      // Cria o usuario
      var user = usuario ?? Usuario();
      user.email = tEmail.text;
      user.setor=1;
      user.nome = tNome.text;
      user.senha = senha;
      user.nivel = _getTipo();
      user.created = hoje;
      user.isativo = true;
      user.login = tEmail.text;
      user.escola = _radioIndex == 0 ? idEscola : 0;

    ApiResponse<bool> response = await UsuariosApi.save(context,user);
      if (response.ok) {
        Email emailx;
        var emaail = emailx ?? Email();
        emaail.nome = tNome.text;
        emaail.assunto = 'Novo Usuário';
        emaail.email= tEmail.text;
        emaail.content= 'Bem vindo ao sistema de Merenda Escolar do Municipio de Agrolândia.Acesse com  ${tEmail.text} e com a senha 123';
        emaail.created= DateTime.now().toString();
        ApiResponse<bool> response = await EmailApi.save(emaail);

        tlogin.clear();
        tEmail.clear();
        tNome.clear();
        tTipo.clear();

        alert(context, "Usuário salvo com sucesso", callback: () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
//        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });

      print("Fim.");
    }
  }

  _onClickCancelar() {
    PagesModel.get(context).pop();
  }

  void _onClickDelete() {
    // Alerta para confirmar
    alertConfirm(context, "Deseja mesmo excluir?", confirmCallback: delete);
  }

  delete() async {
    ApiResponse response = await UsuariosApi.delete(context, usuario);
    if (response.ok) {
      alert(context, response.msg, callback: () {
        PagesModel.get(context).pop();
      });
    } else {
      alert(context, response.msg);
    }
  }

  void _unidadeEscolar(BuildContext context, List<UnidadeEscolar> listEscolas) {
    // configura os botões
    Widget lembrarButton = MaterialButton(
      child: Text("ok"),
      onPressed: () {
        pop(context);
      },
    );
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );

    // configura o  AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Container(
        width: 600,
        child: Column(
          children: [
            MaterialButton(
              child: Icon(Icons.search),
              onPressed: () => buildShowSearch(context, listEscolas),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listEscolas.length,
                itemBuilder: (context, index) {
                  final UnidadeEscolar person = listEscolas[index];
                  return ListTile(
                    title: Text(person.nome),

                    onTap: () {
                      setState(() {
                        idEscola = person.id;
                        nomeEscola = person.nome;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        lembrarButton,
        cancelaButton,
      ],
    );
    // exibe o dialogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<UnidadeEscolar> buildShowSearch(
      BuildContext context, List<UnidadeEscolar> anexo3) {
    return showSearch(
      context: context,
      delegate: SearchPage<UnidadeEscolar>(
        onQueryUpdate: (s) => print(s),
        items: anexo3,
        searchLabel: 'Buscar atividade',
        suggestion: Center(
          child: Text(
              'Digite a atividade ou o código da caracterização sem pontos'),
        ),
        failure: Center(
          child: Text('Nenhum dado encontrado :('),
        ),
        filter: (person) => [
          person.nome,
        ],
        builder: (person) => ListTile(
          title: Text(person.nome),

          onTap: () {
            setState(() {
              nomeEscola = person.nome;
              idEscola = person.id;
            });
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }





}
