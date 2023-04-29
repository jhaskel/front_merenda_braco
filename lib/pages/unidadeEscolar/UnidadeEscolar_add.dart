import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_bloc.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_text_field.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';
import 'package:validadores/Validador.dart';

class UnidadeEscolarAdd extends StatefulWidget {
  final UnidadeEscolar unidadeEscolar;

  UnidadeEscolarAdd({this.unidadeEscolar}) : super();

  @override
  _UnidadeEscolarAddState createState() => _UnidadeEscolarAddState();
}

class _UnidadeEscolarAddState extends State<UnidadeEscolarAdd> {
  UnidadeEscolar get unidadeEscolar => widget.unidadeEscolar;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "unidadeEscolar_form");

  Color cor = Colors.white;
  var _showProgress = false;
  final tNome = TextEditingController();
  final tNivel = TextEditingController();
  final tAlias = TextEditingController();
  final tEndereco = TextEditingController();
  final tBairro = TextEditingController();
  final tAlunos = TextEditingController();

  int idNivel;
  String nomeNivel = '';
  bool _isativo;

  Map<String,int> mapNivel = new Map();
  Map<int,String> mapNivel2 = new Map();
  final _bloc = NivelBloc();
  List<Nivel> nivelEscolar;

  getNomeNivel(String data){
    int jk = int.parse(data);
   if(mapNivel2.containsKey(jk)){
       setState(() {
         idNivel = jk;
       });
       return mapNivel2[jk];
   }
  }


  @override
  void initState() {

    _bloc.fetch(context).then((value) {
      setState(() {
        for(var gh in value){
          mapNivel.putIfAbsent(gh.nome, () => gh.id);
        }
        print("mapnivel${mapNivel}");

        for(var gh in value){
          mapNivel2.putIfAbsent(gh.id, () => gh.nome);
        }
        print("mapnivel2${mapNivel2}");

      });
    });

    // Copia os dados  para o form
    if (unidadeEscolar != null) {
      tNome.text = unidadeEscolar.nome;
      tAlias.text = unidadeEscolar.alias;
      tNivel.text = unidadeEscolar.nivelescolar.toString();
      tEndereco.text = unidadeEscolar.endereco;
      tBairro.text = unidadeEscolar.bairro;
      tAlunos.text = unidadeEscolar.alunos.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BreadCrumb(
      child: body(),
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
                    "Cadastro de Unidades escolares",
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
                      label: "Nome curto",
                      controller: tAlias,
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        //showSelectedItem: true,
                        items: mapNivel.keys.toList(),
                        label: "Nível Escolar",
                        onChanged: (String data)  {
                          setState((){
                            idNivel =  mapNivel[data];
                            nomeNivel = data;
                            print("YYY $idNivel");
                          }
                          );
                        },
                        selectedItem: unidadeEscolar == null ? 'Selecione um nível escolars':getNomeNivel(tNivel.text)
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: AppTextField(
                      label: "Endereço",
                      controller: tEndereco,
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
                      label: "Bairro",
                      controller: tBairro,
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
                      label: "Quantidade de Alunos",
                      controller: tAlunos,
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')

                            .valido(text, clearNoNumber: true);
                      },
                    ),
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

print("TTT $idNivel");
      // Cria o usuario
      var nivel = unidadeEscolar ?? UnidadeEscolar();
      nivel.nome = tNome.text;
      nivel.alias = tAlias.text;
      nivel.nivelescolar = idNivel;
      nivel.endereco = tEndereco.text;
      nivel.bairro = tBairro.text;
      nivel.alunos = int.parse(tAlunos.text);
      nivel.isativo = true;
      nivel.created = hoje;

      ApiResponse<bool> response = await UnidadeEscolarApi.save(context, nivel);

      if (response.ok) {
        alert(context, "UnidadeEscolar salvo com sucesso", callback: () {
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
