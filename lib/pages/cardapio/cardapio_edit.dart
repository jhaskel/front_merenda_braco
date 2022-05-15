import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';
import 'package:merenda_escolar/core/app_text_styles.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_api.dart';
import 'package:merenda_escolar/pages/widgets/app_button.dart';
import 'package:merenda_escolar/pages/widgets/app_tff.dart';
import 'package:merenda_escolar/utils/alert.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:validadores/Validador.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'dart:html';
import 'package:image_web_picker/imagePiker.dart';
import 'package:firebase/firebase.dart' as fb;

class CardapioEdit extends StatefulWidget {
  final Cardapio cardapio;
  CardapioEdit({this.cardapio}) : super();

  @override
  _CardapioEditState createState() => _CardapioEditState();
}

class _CardapioEditState extends State<CardapioEdit> {
  Cardapio get cardapio => widget.cardapio;


  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "cardapio_form");

  Color cor = Colors.white;
  var _showProgress = false;
  final tTitle = TextEditingController();
  final tContent = TextEditingController();
  final tTipo = TextEditingController();

 var picker = ImagePickerWeb();
  List<dynamic> _listaImagens =[];
  List<String> _imagensFinal =[];
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
  Map<String, int> mapTipo = new Map();


  @override
  void initState() {
     //  Copia os dados  para o form
    if (cardapio != null) {
      tTitle.text = cardapio.title;
      image2=cardapio.imagem;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text(cardapio.nomedaescola),),
    body: body(),
    );
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
                  child: image2 != null
                   ? Image.network(
                    image2,
                    height: 200,
                    width: 200,
                  )
                  :Image.asset(
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
          child: Card(
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
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Editar Cardáio",
                          style: AppTextStyles.title,
                        ),
                      ],
                    ),

                    Container(
                    child: _setorImagem(),
                    ),
                    SizedBox(
                      height: 20,
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
                      "Alterar",
                      onPressed: _onClickSalvar,
                      showProgress: _showProgress,
                    ),
                  ],
                ))),
      ),
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
      nivel.title = tTitle.text;
      nivel.imagem = image2;
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
    if( ext== 'jpeg' || ext == 'png'){

        if(file.size > 1999999){
         toast(context,'Imagem muito grande!\nMax 2M',duration: 3);
        print('Imagem muito grande ${file.size}');
      }else{
          setState(() {
            _listaImagens.add(picker.image_memory);
          });
        final filePath = 'cardapio/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
        final ref = "gs://app-orse.appspot.com";
        setState(() {
          _uploadTask = fb
              .storage()
              .refFromURL(ref)
              .child(filePath)
              .put(file);
        });
      }
    }else{
      print('3x');
     toast(context,'Imagens precisa ser imagem jpg ou png !',duration: 3);

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
