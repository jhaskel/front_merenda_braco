
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class EnviarArquivo extends StatefulWidget {

  @override
  _EnviarArquivoState createState() => _EnviarArquivoState();
}

class _EnviarArquivoState extends State<EnviarArquivo> {

  fb.UploadTask _uploadTask;
  String image;
  Image imagem;
  double progressPercent = 0;
  String msg = 'Selecione uma imagem ou arquivo pdf!';
  bool _showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Categorias"),
        centerTitle: true,
      ),
      body: _body(),    );
  }

  _body() {

    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child:  Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(''),
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
                          setState(() {
                            image = value.toString();
                            msg = 'Arquivo enviado com Sucesso!';
                          });

                        });
                        return image != null
                            ? InkWell(
                            onTap: ()async{ await uploadImage();},
                            child: Column(
                              children: [
                                Text(msg),
                                MaterialButton(onPressed: (){

                                }, child: Text('Retornar'))
                              ],

                            )
                        )
                            : Text("");
                      } else if (progressPercent == 0) {


                        return InkWell(
                            onTap: ()async{ await uploadImage();},
                            child: Column(
                              children: [
                                Image.asset('enviarArquivo.png',height: 120,),
                                msg != null ? Text(msg) : Text('')
                              ],
                            )
                        );
                      } else {

                        return LinearProgressIndicator(
                          value: progressPercent,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  uploadToFirebase(File file) async {

    final extensao = file.type.split('/');
    print(extensao);
    String ext = extensao[1];
    print("modficado=${ext[1]}");

    if(ext == 'pdf' ||  ext== 'jpeg' || ext == 'png'){
      if(file.size > 500000){

        setState(() {
          msg = 'Imagem muito grande!';
        });

        print('Imagem muito grande ${file.size}');

      }else{
        final filePath = 'processo/${"kkl"}/comprovantes/${DateTime.now().hashCode}.${ext}';
        print(filePath);
        final ref = "gs://app-merenda-escolar.appspot.com/";
        setState(() {

          _uploadTask = fb
              .storage()
              .refFromURL(ref)
              .child(filePath)
              .put(file);

        });


      }

    }else{
      setState(() {
        msg = 'Documentos precisa ser imagem ou arquivo pdf!';
      });

      print('Documentos precisa ser imagem ou arquivo pdf!');
    }





  }

  uploadImage() async {
    setState(() {
      msg='Selecione uma imagem ou arquivo pdf!';
    });

    // HTML input element
    InputElement uploadInput = FileUploadInputElement();

    uploadInput.click();

    uploadInput.onChange.listen(
          (changeEvent) {
        final  file = uploadInput.files.first;

        final reader = FileReader();

        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen(
              (loadEndEvent) async {
            setState(() {
              uploadToFirebase(file);
            });
          },
        );
      },
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    //  Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _uploadTask?.cancel();
    super.dispose();
  }


}
