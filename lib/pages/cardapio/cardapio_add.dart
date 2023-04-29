import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/core/bloc/escola_bloc.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:provider/provider.dart';

import 'package:validadores/Validador.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:html';
import 'package:image_web_picker/imagePiker.dart';
import 'package:firebase/firebase.dart' as fb;

class CardapioAdd extends StatefulWidget {

  final Cardapio cardapio;

  CardapioAdd({this.cardapio}) : super();

  @override
  _CardapioAddState createState() => _CardapioAddState();
}

class _CardapioAddState extends State<CardapioAdd> {
  Cardapio get cardapio => widget.cardapio;

  Usuario get user => AppModel.get(context).user;
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: "cardapio_form");

  Color cor = Colors.white;
  var _showProgress = false;
  final tNomeEscola = TextEditingController();
  final tTitle = TextEditingController();
  final tImagem = TextEditingController();

  var picker = ImagePickerWeb();
  List<dynamic> _listaImagens = [];
  List<String> _imagensFinal = [];
  fb.UploadTask _uploadTask;
  var image;
  String image2;
  Image imagem;
  double progressPercent = 0;
  String msg = '';
  bool _isLoading = true;
  String tipo;

  int idNivel;
  String nomeEscola = '';

  Map<String, int> mapEscola = new Map();
  Map<int, String> mapEscola2 = new Map();
  Map<String, int> mapTipo = new Map();

  List<UnidadeEscolar> listEscolas;

  getNomeNivel(String data) {
    int jk = int.parse(data);
    if (mapEscola2.containsKey(jk)) {
      setState(() {
        idNivel = jk;
      });
      return mapEscola2[jk];
    }
  }

  @override
  void initState() {
    Provider.of<EscolaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        _isLoading = false;
        for (var gh in value) {
          mapEscola.putIfAbsent(gh.nome, () => gh.id);
        }
        print("mapnivel${mapEscola}");

        for (var gh in value) {
          mapEscola2.putIfAbsent(gh.id, () => gh.nome);
        }
        print("mapnivel2${mapEscola2}");
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
    return Column(
      children: [
        _cardForm(),
      ],
    );
    //  return _cardForm();
  }

  _setorImagem() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _listaImagens.length > 0
              ? Container(
            height: 200,
            child: Image.memory(
              _listaImagens[0],
              height: 200,
              width: 200,
            ),
          )
              : Container(
            height: 200,
            child: Image.asset(
              "assets/images/sem_imagem.png",
              height: 200,
              width: 200,
            ),
          ),

          InkWell(
            onTap: () async {
              picker = await ImagePickerWeb().getImage();
              if (picker.image_memory.length > 0) {
                uploadImageToFirebase(picker);
              }
            },
            child: Container(

              child: _listaImagens.length ==0
                  ?Text('Selecionar Imagem',style: AppTextStyles.bodyBold,)
                  :Text('Alterar Imagem',style: AppTextStyles.bodyBold,),),
          ),


          StreamBuilder<fb.UploadTaskSnapshot>(
            stream: _uploadTask?.onStateChanged,
            builder: (context, snapshot) {
              final event = snapshot?.data;
              // Default as 0
              progressPercent = event != null
                  ? event.bytesTransferred / event.totalBytes * 100
                  : 0;
              if (progressPercent == 100) {
                snapshot.data.ref.getDownloadURL().then((value) {
                  image = value.toString();
                  image2 = value.toString();
                  picker.image_memory = null;
                  print('ix${_imagensFinal.length}');
                  _imagensFinal.clear();
                  _imagensFinal.add(image2);
                  var gh = _imagensFinal.map((e) => e.toLowerCase()).toSet();
                  print('ix${gh}');
                  print('ix${msg}');
                });
                return Text("");
              } else if (progressPercent == 0) {
                return Text("");
              } else {
                return Center(
                  child: LinearProgressIndicator(
                    value: progressPercent,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _cardForm() {
    return Expanded(
      child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              Container(
                child: _setorImagem(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    //showSelectedItem: true,
                    items: mapEscola.keys.toList(),
                    label: "Escola",
                    onChanged: (String data) {
                      setState(() {
                        idNivel = mapEscola[data];
                        nomeEscola = data;
                      });
                    },
                    selectedItem: cardapio == null
                        ? 'Selecione uma escola'
                        : getNomeNivel(tNomeEscola.text)),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  child: AppTFF(
                    label: 'Titulo',
                    hint: 'titulo do cardápio',
                    controller: tTitle,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
              Divider(
                height: 5.0,
              ),
              AppButton(
                "Cadastrar",
                onPressed: _onClickSalvar,
                showProgress: _showProgress,
              ),
            ],
          )),
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
      var nivel = cardapio ?? Cardapio();
      nivel.escola = idNivel;
      nivel.nomedaescola = nomeEscola;
      nivel.title = tTitle.text;
      nivel.imagem = image2;
      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response = await CardapioApi.save(context, nivel);

      if (response.ok) {
        alert(context, "Cardapio salvo com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;

      });
      print("Fim.");
    }
  }

  uploadToFirebase(File file) async {
    final extensao = file.type.split('/');
    print('ext${extensao}');
    String ext = extensao[1];
    print("modficado=${ext[1]}");

    if (ext == 'jpeg' || ext == 'png') {
      if (file.size > 1999999) {
        toast(context, 'Imagem muito grande!\nMax 2M', duration: 3);

        print('Imagem muito grande ${file.size}');
      } else {
        _listaImagens.clear();
        setState(() {
          _listaImagens.add(picker.image_memory);
        });
        final filePath =
            'cardapio/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
        final ref = "gs://app-orse.appspot.com";
        setState(() {
          _uploadTask = fb.storage().refFromURL(ref).child(filePath).put(file);
        });
      }
    } else {
      toast(context, 'Documentos precisa ser imagem jpg ou png !', duration: 3);
    }
  }

  @override
  void dispose() {
    _uploadTask?.cancel();
    super.dispose();
  }

  Future uploadImageToFirebase(ImagePickerWeb imagePickerWeb) async {
    _listaImagens.clear();
    setState(() {
      image = imagePickerWeb.image_upload;
      _listaImagens.add(picker.image_memory);
    });
    uploadToFirebase(image);
  }
}
