import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/pages/widgets/delete_button.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class UsuarioPage extends StatefulWidget {
  final Usuario usuario;
  UsuarioPage({this.usuario});

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  Color color = Colors.grey;

  Usuario get usuario => widget.usuario;

  final tNome = TextEditingController();

  final tSenha= TextEditingController();

  String _hash = '';

  gerarHash(String pass) async {
    var plainPwd = pass;
    DBCrypt dBCrypt = DBCrypt();
    String hashedPwd = await dBCrypt.hashpw(plainPwd, dBCrypt.gensalt());
    String salt = r'$2a$10$C6UzMDM/HUdfI/f7IKxGhu';
    hashedPwd = await dBCrypt.hashpw(plainPwd, salt);
    print(hashedPwd);
    setState(() {
      _hash = hashedPwd;
      print("_hash: ${_hash}");
    });

  }

  @override
  void initState() {
    super.initState();

    if (usuario != null) {
      tNome.text = usuario.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BreadCrumb(
        child: _body(),
        actions: usuario != null
            ? [
          AppButton(
            'Alterar Senha',
            whiteMode: true,
            onPressed: (){
              showAlterarSenha(context,usuario);
            },
          )
              ]
            : null,
      ),
    );
  }

  _body() {
    return _cardForm();
  }

  _cardForm() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _form(),
            ],
          ),
        ),
      ),
    );
  }

  Form _form() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppTextField(
            label: "Nome",
            controller: tNome,

            required: true,
          ),
          SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  _onClickCancelar() {
    PagesModel.get(context).pop();
  }

  _onClickSalvar() async {

    await gerarHash(tSenha.text);
    print("depois${_hash}");
    print("passou");
    var hoje = DateTime.now().toIso8601String();

    // Cria o usuario
    var user = usuario ?? Usuario();
    user.nome =tNome.text;
    user.modified = hoje;

    ApiResponse<bool> response = await UsuariosApi.save(context,user);

    if (response.ok) {

      alert(context, "Usuário salvo com sucesso", callback: () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
//        alert(context, response.msg);
    }


  }
  _onClickSenha(String text) async {

    await gerarHash(text);
    print("depois${_hash}");
    print("passou");
    var hoje = DateTime.now().toIso8601String();

    var user = usuario ?? Usuario();
    user.senha =_hash;
    user.modified = hoje;
    ApiResponse<bool> response = await UsuariosApi.save(context,user);
    if (response.ok) {
      tSenha.clear();
      Email emailx;
      var emaail = emailx ?? Email();
      emaail.nome = usuario.nome;
      emaail.assunto = 'Alteração de Senha!';
      emaail.email= usuario.email;
      emaail.content= 'Você alterou sua Senha em ${hoje}.';
      emaail.created= DateTime.now().toString();
      await EmailApi.save(emaail);

      toast(context,'Cadastro realizado com Sucesso');

    } else {
//        alert(context, response.msg);
    }


  }



  void _onClickDelete() {
    // Alerta para confirmar
    alertConfirm(context, "Deseja mesmo excluir?", confirmCallback: (){
      print("não implementado...");
    });
  }

  showAlterarSenha(BuildContext context, Usuario usuario) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {
        pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        _onClickSenha(tSenha.text);
        pop(context);
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alterar Senha"),
      content: Container(
        height: 100,
        width: 300,
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.only(left: 20),
              child: AppTextField(
                label: "Nova Senha",
                controller: tSenha,
                keyboardType: TextInputType.text,
                required: true,
                password: true,

              ),
            ),

          ],

        ),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
