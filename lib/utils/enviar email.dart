
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/pages/email/email_api.dart';
import 'package:merenda_escolar/utils/api_response.dart';

class EmailPage extends StatefulWidget {

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
   Email emailx;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: RaisedButton(
            onPressed: () async {
              var emaail = emailx ?? Email();
              emaail.nome = "joao Haskel";
              emaail.assunto = 'Novo Empreendedor';
              emaail.email= 'johaskel@gmail.com';
              emaail.content= 'Bem vindo ao sistema de licenciamento ambiental. Acesso com o numero de seu CPF ou CNPJ com pontos e digito ';
              emaail.created= DateTime.now().toString();
              ApiResponse<bool> response = await EmailApi.save(emaail);

            },
        child: Text('Envia email'),),
      ),
    );
  }
}
