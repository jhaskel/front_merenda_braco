import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/pages/config/config_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:validadores/Validador.dart';

class ConfigAdd extends StatefulWidget {
  Config config;
  ConfigAdd({this.config});
  @override
  _ConfigAddState createState() => _ConfigAddState();
}

class _ConfigAddState extends State<ConfigAdd> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "config_form");

  Config get config =>widget.config;
  Color cor = Colors.white;

  var _showProgress = false;
  final tNome = TextEditingController();
  final tAlias = TextEditingController();
  final tUnidade = TextEditingController();


  @override
  void initState() {
    super.initState();
    if(config !=null){
      tNome.text = config.nomeContato;
      tAlias.text = config.email;
      tUnidade.text = config.cargo;
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: config!=null ?AppBar(title: Text("Editar ${config.nomeContato}"),centerTitle: true,):null,

  body: BreadCrumb(
    child: _body(),
  )
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
                  config !=null
                      ? Text(
                    "Editar  Config",
                    style: Theme.of(context).textTheme.headline5,
                  )
                  :Text(
                    "Cadastro de Configs",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome do config',
                    maxLines: 4,
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Email',
                    hint: 'digite seu email',
                    controller: tAlias,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Cargo',
                    hint: 'Cargo que ocupa',
                    controller: tUnidade,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),


                  SizedBox(
                    height: 20,
                  ),



                  Divider(
                    height: 10.0,
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
   print("chegou");
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });
      var hoje = DateTime.now().toIso8601String();

      // Cria o usuario
      var produ = config ?? Config();

      produ.nomeContato = tNome.text;
      produ.email = tAlias.text;
      produ.cargo = tUnidade.text;

      ApiResponse<bool> response = await ConfigApi.save(context, produ);

      if (response.ok) {

        alert(context, "Config salvo com sucesso", callback: () {
          tNome.clear();
          tAlias.clear();
          tUnidade.clear();
          Navigator.pop(context);

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
